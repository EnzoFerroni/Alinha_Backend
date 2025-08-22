//
//  OrganizationController.swift
//  Challenge7_Backend
//
//  Created by Enzo Ferroni on 19/08/25.
//

import Vapor

struct OrganizationsController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let organizations = routes.grouped("organizations")
        organizations.get(use: index)
        organizations.post(use: create)
        
        organizations.group(":id") { organization in
            organization.patch("name", use: updateName)
            organization.patch("appointmentPlaces", use: updateAppointmentPlaces)
            organization.patch("mentors", use: updateMentors)
            organization.patch("availableMentors", use: updateAvailableMentors)
            organization.patch("queue", use: updateQueue)
            organization.patch("unscheduleQueue", use: updateUnscheduleQueue)
            organization.get(use: show)
            organization.get("queue", use: getQueue)
            organization.get("unscheduleQueue", use: getUnscheduleQueue)
            organization.patch("addAppointmentToQueue", use: addAppointmentToQueue)
            organization.patch("addAppointmentToUnscheduleQueue", use: addAppointmentToUnscheduleQueue)
            organization.patch("removeFirstAppointmentFromQueue", use: removeFirstAppointmentFromQueue)
            organization.patch("removeFirstAppointmentFromUnscheduleQueue", use: removeFirstAppointmentFromUnscheduleQueue)
            
            organization.delete(use: delete)
            
        }
    }
    
    func index(req: Request) async throws -> [OrganizationDTO] {
        try await Organization.query(on: req.db).all().map { $0.toDTO()}
    }
    
    func create(req: Request) async throws -> OrganizationDTO {
        let organization = try req.content.decode(OrganizationDTO.self)
        let organizationModel = organization.toModel()
        try await organizationModel.save(on: req.db)
        return organization
    }
    
    
    func show(req: Request) async throws -> OrganizationDTO {
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return organization.toDTO()
    }
    
    func getQueue(req: Request) async throws -> OrganizationDTO.GetQueue {
        let create = try req.content.decode(OrganizationDTO.GetQueue.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return create
    }
    
    func getUnscheduleQueue(req: Request) async throws -> OrganizationDTO.GetUnscheduleQueue {
        let create = try req.content.decode(OrganizationDTO.GetUnscheduleQueue.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return create
    }
    
    func updateName(req: Request) async throws -> OrganizationDTO.UpdateName {
        let create = try req.content.decode(OrganizationDTO.UpdateName.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        organization.name = create.name
        try await organization.update(on: req.db)
        return create
    }
    
    func updateAppointmentPlaces(req: Request) async throws -> OrganizationDTO.UpdateAppointmentPlaces {
        let create = try req.content.decode(OrganizationDTO.UpdateAppointmentPlaces.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        organization.appointmentPlaces = create.appointmentPlaces
        try await organization.update(on: req.db)
        return create
    }
    
    func updateMentors(req: Request) async throws -> OrganizationDTO.UpdateMentors {
        let create = try req.content.decode(OrganizationDTO.UpdateMentors.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        organization.mentors = create.mentors
        try await organization.update(on: req.db)
        return create
    }
    
    func updateAvailableMentors(req: Request) async throws -> OrganizationDTO.UpdateAvailableMentors {
        let create = try req.content.decode(OrganizationDTO.UpdateAvailableMentors.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        organization.availableMentors = create.availableMentors
        try await organization.update(on: req.db)
        return create
    }
    
    func updateQueue(req: Request) async throws -> OrganizationDTO.UpdateQueue {
        let create = try req.content.decode(OrganizationDTO.UpdateQueue.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        organization.queue = create.queue
        try await organization.update(on: req.db)
        return create
    }
    
    func addAppointmentToQueue(req: Request) async throws -> OrganizationDTO.AddAppointmentToQueue {
        let create = try req.content.decode(OrganizationDTO.AddAppointmentToQueue.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        organization.queue.append(create.appointment)
        try await organization.update(on: req.db)
        return create
    }
    
    func addAppointmentToUnscheduleQueue(req: Request) async throws -> OrganizationDTO.AddAppointmentToUnscheduleQueue {
        let create = try req.content.decode(OrganizationDTO.AddAppointmentToUnscheduleQueue.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        organization.unscheduleQueue.append(create.appointment)
        try await organization.update(on: req.db)
        return create
    }
    
    func removeFirstAppointmentFromQueue(req: Request) async throws -> OrganizationDTO.RemoveFirstAppointmentFromQueue {
        let create = try req.content.decode(OrganizationDTO.RemoveFirstAppointmentFromQueue.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        guard !organization.queue.isEmpty else {
            throw Abort(.badRequest, reason: "Queue is empty")
        }
        organization.queue.removeFirst()
        try await organization.update(on: req.db)
        return create
    }
    
    func removeFirstAppointmentFromUnscheduleQueue(req: Request) async throws -> OrganizationDTO.RemoveFirstAppointmentFromUnscheduleQueue {
        let create = try req.content.decode(OrganizationDTO.RemoveFirstAppointmentFromUnscheduleQueue.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        guard !organization.unscheduleQueue.isEmpty else {
            throw Abort(.badRequest, reason: "Unschedule Queue is empty")
        }
        organization.unscheduleQueue.removeFirst()
        try await organization.update(on: req.db)
        return create
    }
    
    func updateUnscheduleQueue(req: Request) async throws -> OrganizationDTO.UpdateUnscheduleQueue {
        let create = try req.content.decode(OrganizationDTO.UpdateUnscheduleQueue.self)
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        organization.unscheduleQueue = create.unscheduleQueue
        try await organization.update(on: req.db)
        return create
    }
    
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await organization.delete(on: req.db)
        return .ok
    }
    
}
