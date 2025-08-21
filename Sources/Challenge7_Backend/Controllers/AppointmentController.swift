//
//  File.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 19/08/25.
//

import Fluent
import Vapor

struct AppointmentController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let appointments = routes.grouped("appointments")
        appointments.get(use: index)
        appointments.post(use: create)
        
        appointments.group(":id") { appointment in
            appointment.get(use: show)
            appointment.delete(use: delete)
            appointment.patch("mentor", use: updateMentor)
            appointment.patch("place", use: updatePlace)
            appointment.patch("isScheduled", use: updateScheduled)
            appointment.patch("callStudent", use: updateCallStudent)
            appointment.patch("isDone", use: updateIsDone)
        }
    }
    
    func index(req: Request) async throws -> [AppointmentDTO] {
        try await Appointment.query(on: req.db).all().map { $0.toDTO() }
    }
    
    func create(req: Request) async throws -> AppointmentDTO {
        let appointment = try req.content.decode(AppointmentDTO.self)
        let appointmentModel = appointment.toModel()
        try await appointmentModel.save(on: req.db)
        return appointment
    }
    
    func show(req: Request) async throws -> AppointmentDTO {
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return appointment.toDTO()
    }
    
    func updateMentor(req: Request) async throws -> AppointmentDTO.UpdateMentor {
        let create = try req.content.decode(AppointmentDTO.UpdateMentor.self)
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.mentor = create.mentor
        try await appointment.update(on: req.db)
        return create
    }
    
    func updatePlace(req: Request) async throws -> AppointmentDTO.UpdatePlace {
        let create = try req.content.decode(AppointmentDTO.UpdatePlace.self)
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        appointment.appointmentPlace = create.appointmentPlace
        try await appointment.update(on: req.db)
        return create
    }
    
    func updateScheduled(req: Request) async throws -> AppointmentDTO.UpdateScheduled {
        let create = try req.content.decode(AppointmentDTO.UpdateScheduled.self)
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.isScheduled = create.isScheduled
        try await appointment.update(on: req.db)
        return create
    }
    
    func updateCallStudent(req: Request) async throws -> AppointmentDTO.UpdateCallStudent {
        let create = try req.content.decode(AppointmentDTO.UpdateCallStudent.self)
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.callStudent = create.callStudent
        try await appointment.update(on: req.db)
        return create
    }
    
    func updateIsDone(req: Request) async throws -> AppointmentDTO.UpdateDone {
        let create = try req.content.decode(AppointmentDTO.UpdateDone.self)
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        appointment.isDone = create.isDone
        try await appointment.update(on: req.db)
        return create
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await appointment.delete(on: req.db)
        return .ok
    }
}
