//
//  File.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 19/08/25.
//

import Fluent
import Vapor

/// Controller for managing Appointment resources and their API endpoints.
struct AppointmentController: RouteCollection {
    /// Registers Appointment routes to the provided router.
    /// - Parameter routes: The router to register routes to.
    func boot(routes: any RoutesBuilder) throws {
        let appointments = routes.grouped("appointments")
        
        // Only mentors OR admins can mutate appointments or call next
        let protected = appointments.grouped(AdmMentorMiddleware())
        
        appointments.get(use: index)
        appointments.post(use: create)
        protected.patch("place", use: updatePlace)
        protected.patch("isScheduled", use: updateScheduled)
        protected.patch("callStudent", use: updateCallStudent)
        protected.patch("isDone", use: updateIsDone)
        protected.post("next", use: next)
        
        appointments.group(":id") { appointment in
            appointment.get(use: show)
            let secured = appointment.grouped(AdmMentorMiddleware())
            secured.delete(use: delete)
            secured.patch("place", use: updatePlaceById)
            secured.patch("isScheduled", use: updateScheduledById)
            secured.patch("callStudent", use: updateCallStudentById)
            secured.patch("isDone", use: updateIsDoneById)
        }
    }
    
    /// Returns a list of appointments with optional status filtering and naive pagination.
    /// Query params:
    /// - status: waiting | scheduled | done (optional)
    /// - page: Int (1-based, optional)
    /// - per:  Int (items per page, optional, default 20, max 100)
    func index(req: Request) async throws -> [AppointmentDTO] {
        var qb = Appointment.query(on: req.db)

        // Filtering by queue status
        if let status = req.query[String.self, at: "status"]?.lowercased() {
            switch status {
            case "waiting":
                qb = qb.filter(\.$isDone == false).filter(\.$isScheduled == false)
            case "scheduled":
                qb = qb.filter(\.$isDone == false).filter(\.$isScheduled == true)
            case "done":
                qb = qb.filter(\.$isDone == true)
            default:
                break
            }
        }

        // Order by createdAt ascending (queue order)
        qb = qb.sort(\.$createdAt, .ascending)

        // Simple pagination using range
        let page = max(1, req.query[Int.self, at: "page"] ?? 1)
        let perRaw = req.query[Int.self, at: "per"] ?? 20
        let per = min(max(1, perRaw), 100)
        let lower = (page - 1) * per
        let upper = lower + per
        let results = try await qb.range(lower..<upper).all()
        return results.map { $0.toDTO() }
    }
    
    /// Creates a new appointment (enqueue). Ignores client flags and sets server-side defaults
    /// to make it safe as a waiting-queue entry.
    /// - Note: For a real queue by student, link the authenticated user here (requires model field).
    func create(req: Request) async throws -> AppointmentDTO {
        // Decode a broad DTO but DO NOT trust client flags or createdAt
        let input = try req.content.decode(AppointmentDTO.self)

        // Validate required business fields locally to avoid ! crashes
        guard let place = input.appointmentPlace, !place.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw Abort(.badRequest, reason: "appointmentPlace is required")
        }
        guard let category = input.appointmentCategory else {
            throw Abort(.badRequest, reason: "appointmentCategory is required")
        }
        // Mentor remains optional; prefer storing an ID in the model if available
        let mentor = input.mentor

        // Server authority for queue semantics
        let model = Appointment(
            mentor: mentor ?? "EMPTY MENTOR",
            appointmentPlace: place,
            appointmentCategory: category,
            isScheduled: false, // start waiting in queue
            callStudent: false,
            isDone: false,
            createdAt: Date()   // server timestamp
        )
        try await model.save(on: req.db)
        return model.toDTO()
    }
    
    /// Returns a specific appointment by ID.
    /// - Returns: The requested AppointmentDTO.
    func show(req: Request) async throws -> AppointmentDTO {
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return appointment.toDTO()
    }
    
    /// Updates the place of an appointment.
    /// - Returns: The updated appointment DTO.
    func updatePlace(req: Request) async throws -> AppointmentDTO {
        let create = try req.content.decode(AppointmentDTO.UpdatePlace.self)
        guard let appointment = try await Appointment.find(create.appointmentId, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.appointmentPlace = create.appointmentPlace
        try await appointment.update(on: req.db)
        // Return the canonical state from DB (avoid client/server drift)
        return appointment.toDTO()
    }
    
    /// Updates the scheduled status of an appointment.
    /// - Returns: The updated appointment DTO.
    func updateScheduled(req: Request) async throws -> AppointmentDTO {
        let create = try req.content.decode(AppointmentDTO.UpdateScheduled.self)
        guard let appointment = try await Appointment.find(create.appointmentId, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.isScheduled = create.isScheduled
        try await appointment.update(on: req.db)
    
        return appointment.toDTO()
    }
    
    /// Updates the callStudent status of an appointment.
    /// - Returns: The updated appointment DTO.
    func updateCallStudent(req: Request) async throws -> AppointmentDTO {
        let create = try req.content.decode(AppointmentDTO.UpdateCallStudent.self)
        guard let appointment = try await Appointment.find(create.appointmentId, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.callStudent = create.callStudent
        try await appointment.update(on: req.db)

        return appointment.toDTO()
    }
    
    /// Updates the done status of an appointment.
    /// - Returns: The updated appointment DTO.
    func updateIsDone(req: Request) async throws -> AppointmentDTO {
        let create = try req.content.decode(AppointmentDTO.UpdateDone.self)
        guard let appointment = try await Appointment.find(create.appointmentId, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.isDone = create.isDone
        try await appointment.update(on: req.db)
       
        return appointment.toDTO()
    }
    
    /// Deletes an appointment by ID.
    /// - Returns: Deleted message if successful.
    func delete(req: Request) async throws -> String {
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await appointment.delete(on: req.db)
        return "Appointment deleted."
    }
    

    /// PATCH /appointments/:id/place { "appointmentPlace": String }
    func updatePlaceById(req: Request) async throws -> AppointmentDTO {
        struct Body: Content { let appointmentPlace: String }
        let body = try req.content.decode(Body.self)
        guard let idString = req.parameters.get("id"),
              let id = UUID(uuidString: idString),
              let appointment = try await Appointment.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.appointmentPlace = body.appointmentPlace
        try await appointment.update(on: req.db)
        return appointment.toDTO()
    }

    /// PATCH /appointments/:id/isScheduled { "isScheduled": Bool }
    func updateScheduledById(req: Request) async throws -> AppointmentDTO {
        struct Body: Content { let isScheduled: Bool }
        let body = try req.content.decode(Body.self)
        guard let idString = req.parameters.get("id"),
              let id = UUID(uuidString: idString),
              let appointment = try await Appointment.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.isScheduled = body.isScheduled
        try await appointment.update(on: req.db)
        return appointment.toDTO()
    }

    func updateCallStudentById(req: Request) async throws -> AppointmentDTO {
        struct Body: Content { let callStudent: Bool }
        let body = try req.content.decode(Body.self)
        
        guard let idString = req.parameters.get("id"),
              let id = UUID(uuidString: idString),
              let appointment = try await Appointment.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        appointment.callStudent = body.callStudent
        try await appointment.update(on: req.db)
        return appointment.toDTO()
    }

    /// PATCH /appointments/:id/isDone { "isDone": Bool }
    func updateIsDoneById(req: Request) async throws -> AppointmentDTO {
        struct Body: Content { let isDone: Bool }
        let body = try req.content.decode(Body.self)
        guard let idString = req.parameters.get("id"),
              let id = UUID(uuidString: idString),
              let appointment = try await Appointment.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.isDone = body.isDone
        try await appointment.update(on: req.db)
        return appointment.toDTO()
    }

    
    func next(req: Request) async throws -> AppointmentDTO {
        return try await req.db.transaction { db in
            // Oldest waiting = not done & not scheduled
            guard let appt = try await Appointment.query(on: db)
                .filter(\.$isDone == false)
                .filter(\.$isScheduled == false)
                .sort(\.$createdAt, .ascending)
                .first() else {
                throw Abort(.notFound, reason: "No waiting appointments")
            }
            appt.isScheduled = true
            try await appt.update(on: db)
            return appt.toDTO()
        }
    }
}
