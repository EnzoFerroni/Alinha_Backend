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
        appointments.get(use: index)
        appointments.post(use: create)
        appointments.delete(use: delete)
        appointments.patch("mentor", use: updateMentor)
        appointments.patch("place", use: updatePlace)
        appointments.patch("isScheduled", use: updateScheduled)
        appointments.patch("callStudent", use: updateCallStudent)
        appointments.patch("isDone", use: updateIsDone)
        
        appointments.group(":id") { appointment in
            appointment.get(use: show)
        }
    }
    
    /// Returns a list of all appointments.
    func index(req: Request) async throws -> [AppointmentDTO] {
        try await Appointment.query(on: req.db).all().map { $0.toDTO() }
    }
    
    /// Creates a new appointment.
    /// - Returns: The created AppointmentDTO.
    func create(req: Request) async throws -> AppointmentDTO {
        let appointment = try req.content.decode(AppointmentDTO.self)
        let appointmentModel = Appointment(
            organization: appointment.organization!,
            mentor: appointment.mentor!,
            student: appointment.student!,
            appointmentPlace: appointment.appointmentPlace!,
            appointmentCategory: appointment.appointmentCategory!,
            appointmentType: appointment.appointmentType!,
            isScheduled: appointment.isScheduled ?? false,
            callStudent: appointment.callStudent ?? false,
            isDone: appointment.isDone ?? false,
            createdAt: appointment.createdAt!
        )
        try await appointmentModel.save(on: req.db)
        return appointment
    }
    
    /// Returns a specific appointment by ID.
    /// - Returns: The requested AppointmentDTO.
    func show(req: Request) async throws -> AppointmentDTO {
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return appointment.toDTO()
    }
    
    /// Updates the mentor of an appointment.
    /// - Returns: The updated mentor DTO.
    func updateMentor(req: Request) async throws -> AppointmentDTO.UpdateMentor {
        let create = try req.content.decode(AppointmentDTO.UpdateMentor.self)
        guard let appointment = try await Appointment.find(create.appointmentId, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.mentor = create.mentor
        try await appointment.update(on: req.db)
        return create
    }
    
    /// Updates the place of an appointment.
    /// - Returns: The updated place DTO.
    func updatePlace(req: Request) async throws -> AppointmentDTO.UpdatePlace {
        let create = try req.content.decode(AppointmentDTO.UpdatePlace.self)
        guard let appointment = try await Appointment.find(create.appointmentId, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.appointmentPlace = create.appointmentPlace
        try await appointment.update(on: req.db)
        return create
    }
    
    /// Updates the scheduled status of an appointment.
    /// - Returns: The updated scheduled DTO.
    func updateScheduled(req: Request) async throws -> AppointmentDTO.UpdateScheduled {
        let create = try req.content.decode(AppointmentDTO.UpdateScheduled.self)
        guard let appointment = try await Appointment.find(create.appointmentId, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.isScheduled = create.isScheduled
        try await appointment.update(on: req.db)
        return create
    }
    
    /// Updates the callStudent status of an appointment.
    /// - Returns: The updated callStudent DTO.
    func updateCallStudent(req: Request) async throws -> AppointmentDTO.UpdateCallStudent {
        let create = try req.content.decode(AppointmentDTO.UpdateCallStudent.self)
        guard let appointment = try await Appointment.find(create.appointmentId, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.callStudent = create.callStudent
        try await appointment.update(on: req.db)
        return create
    }
    
    /// Updates the done status of an appointment.
    /// - Returns: The updated done DTO.
    func updateIsDone(req: Request) async throws -> AppointmentDTO.UpdateDone {
        let create = try req.content.decode(AppointmentDTO.UpdateDone.self)
        guard let appointment = try await Appointment.find(create.appointmentId, on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.isDone = create.isDone
        try await appointment.update(on: req.db)
        return create
    }
    
    /// Deletes an appointment by ID.
    /// - Returns: Deleted message if successful.
    func delete(req: Request) async throws -> String {
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await appointment.delete(on: req.db)
        return "Agendamento deletado com sucesso!"
    }
}
