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
            appointment.patch("isScheduled", use: updateIsScheduled)
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
    
    func updateMentor(req: Request) async throws -> AppointmentDTO {
        guard let appointment = try await Appointment.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let mentor = try req.content.get(UUID.self, at: "mentor")
        appointment.mentor = mentor
        try await appointment.save(on: req.db)
        return appointment.toDTO()
    }

    func updatePlace(req: Request) async throws -> AppointmentDTO {
        guard let appointment = try await Appointment.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let appointmentPlace = try req.content.get(String.self, at: "appointmentPlace")
        appointment.appointmentPlace = appointmentPlace
        try await appointment.save(on: req.db)
        return appointment.toDTO()
    }

    func updateIsScheduled(req: Request) async throws -> AppointmentDTO {
        guard let appointment = try await Appointment.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let isScheduled = try req.content.get(Bool.self, at: "isScheduled")
        appointment.isScheduled = isScheduled
        try await appointment.save(on: req.db)
        return appointment.toDTO()
    }

    func updateCallStudent(req: Request) async throws -> AppointmentDTO {
        guard let appointment = try await Appointment.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let callStudent = try req.content.get(Bool.self, at: "callStudent")
        appointment.callStudent = callStudent
        try await appointment.save(on: req.db)
        return appointment.toDTO()
    }

    func updateIsDone(req: Request) async throws -> AppointmentDTO {
        guard let appointment = try await Appointment.find(req.parameters.require("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let isDone = try req.content.get(Bool.self, at: "isDone")
        appointment.isDone = isDone
        try await appointment.save(on: req.db)
        return appointment.toDTO()
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let appointment = try await Appointment.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await appointment.delete(on: req.db)
        return .ok
    }
}
