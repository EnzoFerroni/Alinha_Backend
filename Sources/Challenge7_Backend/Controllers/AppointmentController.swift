//
//  File.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 19/08/25.
//

import Fluent
import Vapor
import Foundation

/// Controller for managing Appointment resources and their API endpoints.
struct AppointmentController: RouteCollection {
    /// Registers Appointment routes to the provided router.
    /// - Parameter routes: The router to register routes to.
    func boot(routes: any RoutesBuilder) throws {
        let appointments = routes.grouped("appointments")
        
        // Only mentors OR admins can mutate appointments or call next
        let authenticated = appointments.grouped(User.authenticator())
        let protected = authenticated.grouped(AdmMentorMiddleware())
        
        appointments.get(use: index)
        appointments.post(use: create)
        protected.patch("place", use: updatePlace)
        protected.patch("isScheduled", use: updateScheduled)
        protected.patch("callStudent", use: updateCallStudent)
        protected.patch("isDone", use: updateIsDone)
        protected.patch("mentor", use: updateMentor)
        
        appointments.group(":id") { appointment in
            appointment.get(use: show)
            let authenticatedId = appointment.grouped(User.authenticator())
            let secured = authenticatedId.grouped(AdmMentorMiddleware())
            secured.delete(use: delete)
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
        guard let place = input.appointmentPlace, !place.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            throw Abort(.badRequest, reason: "appointmentPlace is required")
        }
        
        guard let description = input.description, !description.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            throw Abort(.badRequest, reason: "appointment desc is required")
        }
        
        guard let deviceToken = input.deviceToken, !deviceToken.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            throw Abort(.badRequest, reason: "device desc is required")
        }
        
        guard let typeEnum = input.type else {
            throw Abort(.badRequest, reason: "invalid or missing type")
        }
        
        guard let pathEnum = input.path else {
            throw Abort(.badRequest, reason: "invalid or missing path")
        }
        
        guard let user = try await User.find(input.student, on: req.db)else{
            throw Abort(.badRequest, reason: "user unfound")
        }
        
        // Server authority for queue semantics — set parent by ID to avoid eager-load pitfalls
        let userId = try user.requireID()
        let model = Appointment()
        
        model.mentor = input.mentor ?? "EMPTY MENTOR"
        model.appointmentPlace = place
        model.description = description
        model.$student.id = userId
        model.isScheduled = false   // start waiting in queue
        model.callStudent = false
        model.isDone = false
        model.deviceToken = deviceToken
        model.type = typeEnum
        model.path = pathEnum
        // createdAt is handled automatically by @Timestamp(on: .create)
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

        do {
            try await req.apns.client.sendAlertNotification(
                alert,
                deviceToken: appointment.deviceToken
            )
        }
        catch {
            throw Abort(.forbidden)
        }
        
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
    
    /// Updates the done status of an appointment.
    /// - Returns: The updated appointment DTO.
    func updateMentor(req: Request) async throws -> AppointmentDTO {
        let create = try req.content.decode(AppointmentDTO.UpdateMentor.self)
        guard let appointment = try await Appointment.find(create.appointmentId, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.mentor = create.mentor
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
}
