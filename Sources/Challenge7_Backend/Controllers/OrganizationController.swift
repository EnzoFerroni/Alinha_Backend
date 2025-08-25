//
//  OrganizationController.swift
//  Challenge7_Backend
//
//  Created by Enzo Ferroni on 19/08/25.
//

import Vapor

struct OrganizationsController: RouteCollection {
    /// Initializes all routes
    /// - Parameter routes: builds routes
    func boot(routes: any RoutesBuilder) throws {
        let organizations = routes.grouped("organizations")
        organizations.get(use: index)
        organizations.post(use: create)
        organizations.get("getOrganizationByToken", use: getOrganizationByToken)
        organizations.patch("name", use: updateName)
        organizations.patch("appointmentPlaces", use: updateAppointmentPlaces)
        organizations.patch("users", use: updateUsers)
        organizations.patch("availableMentors", use: updateAvailableMentors)
        organizations.patch("queue", use: updateQueue)
        organizations.patch("unscheduleQueue", use: updateUnscheduleQueue)
        organizations.patch("addAppointmentToQueue", use: addAppointmentToQueue)
        organizations.patch("addAppointmentToUnscheduleQueue", use: addAppointmentToUnscheduleQueue)
        organizations.patch("removeFirstAppointmentFromQueue", use: removeFirstAppointmentFromQueue)
        organizations.patch("removeFirstAppointmentFromUnscheduleQueue", use: removeFirstAppointmentFromUnscheduleQueue)
        
        organizations.group(":id") { organization in
            organization.get(use: show)
            organization.delete(use: delete)
            
        }
    }
    
    /// Fetches all organizations
    func index(req: Request) async throws -> [OrganizationDTO] {
        try await Organization.query(on: req.db).all().map { $0.toDTO() }
    }
    
    /// Creates an organization
    func create(req: Request) async throws -> OrganizationDTO {
        let organization = try req.content.decode(OrganizationDTO.self)
        let organizationModel = Organization(
            name: organization.name ?? "",
            token: generateToken(),
            appointmentPlaces: organization.appointmentPlaces ?? [],
            users: organization.users ?? [],
            availableMentors: organization.availableMentors ?? [],
            queue: organization.queue ?? [],
            unscheduleQueue: organization.unscheduleQueue ?? []
        )
        try await organizationModel.save(on: req.db)
        return organizationModel.toDTO()
    }
    
    /// Fetches the organization based on a unique ID
    func show(req: Request) async throws -> OrganizationDTO {
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return organization.toDTO()
    }
    
    /// Fetches organization by token
    func getOrganizationByToken(req: Request) async throws -> OrganizationDTO {
        let tokenRequest = try req.content.decode(OrganizationDTO.GetOrganizationByToken.self)
        guard let organization = try await Organization.query(on: req.db)
            .filter(\.$token, .equal, tokenRequest.token)
            .first() else {
            throw Abort(.notFound)
        }
        return organization.toDTO()
    }
    
    func generateToken() -> String {
        let characters = "0123456789"
        return String((0..<6).map { _ in characters.randomElement()! })
    }
    
    func getAppointmentPlaces(req: Request) async throws -> [OrganizationDTO] {
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return [organization.toDTO()]
    }
    
    /// Fetches the organization queue
    func getQueue(req: Request) async throws -> OrganizationDTO.GetQueue {
        let get = try req.content.decode(OrganizationDTO.GetQueue.self)
        guard let organization = try await Organization.find(get.id, on: req.db) else {
            throw Abort(.notFound)
        }
        return OrganizationDTO.GetQueue(id: <#UUID#>, queue: organization.queue)
    }
    
    /// Fetches the unscheduled appointments queue
    func getUnscheduleQueue (req: Request) async throws -> OrganizationDTO.GetUnscheduleQueue {
        let get = try req.content.decode(OrganizationDTO.GetUnscheduleQueue.self)
        guard let organization = try await Organization.find(get.id, on: req.db) else {
            throw Abort(.notFound)
        }
        return OrganizationDTO.GetUnscheduleQueue(id: <#UUID#>, unscheduleQueue: organization.unscheduleQueue)
    }
    
    /// Updates organization name
    func updateName(req: Request) async throws -> OrganizationDTO.UpdateName {
        let update = try req.content.decode(OrganizationDTO.UpdateName.self)
        guard let organization = try await Organization.find(update.id, on: req.db) else {
            throw Abort(.notFound)
        }
        organization.name = update.name
        try await organization.update(on: req.db)
        return update
    }
    
    /// Updates organization appointment places
    func updateAppointmentPlaces(req: Request) async throws -> OrganizationDTO.UpdateAppointmentPlaces {
        let update = try req.content.decode(OrganizationDTO.UpdateAppointmentPlaces.self)
        guard let organization = try await Organization.find(update.id, on: req.db) else {
            throw Abort(.notFound)
        }
        organization.appointmentPlaces = update.appointmentPlaces
        try await organization.update(on: req.db)
        return update
    }
    
    /// Updates all organization users
    func updateUsers(req: Request) async throws -> OrganizationDTO.UpdateUsers {
        let update = try req.content.decode(OrganizationDTO.UpdateUsers.self)
        guard let organization = try await Organization.find(update.id, on: req.db) else {
            throw Abort(.notFound)
        }
        organization.users = update.users
        try await organization.update(on: req.db)
        return update
    }
    
    /// Updates organization available users
    func updateAvailableMentors(req: Request) async throws -> OrganizationDTO.UpdateAvailableMentors {
        let update = try req.content.decode(OrganizationDTO.UpdateAvailableMentors.self)
        guard let organization = try await Organization.find(update.id, on: req.db) else {
            throw Abort(.notFound)
        }
        organization.availableMentors = update.availableMentors
        try await organization.update(on: req.db)
        return update
    }
    
    /// Updates organization queue
    func updateQueue(req: Request) async throws -> OrganizationDTO.UpdateQueue {
        let update = try req.content.decode(OrganizationDTO.UpdateQueue.self)
        guard let organization = try await Organization.find(update.id, on: req.db) else {
            throw Abort(.notFound)
        }
        organization.queue = update.queue
        try await organization.update(on: req.db)
        return update
    }
    
    /// Updates organization unschedule queue
    func updateUnscheduleQueue(req: Request) async throws -> OrganizationDTO.UpdateUnscheduleQueue {
        let update = try req.content.decode(OrganizationDTO.UpdateUnscheduleQueue.self)
        guard let organization = try await Organization.find(update.id, on: req.db) else {
            throw Abort(.notFound)
        }
        organization.unscheduleQueue = update.unscheduleQueue
        try await organization.update(on: req.db)
        return update
    }
    
    /// Adds a new appointment to queue
    func addAppointmentToQueue(req: Request) async throws -> OrganizationDTO.AddAppointmentToQueue {
        let add = try req.content.decode(OrganizationDTO.AddAppointmentToQueue.self)
        guard let organization = try await Organization.find(add.id, on: req.db) else {
            throw Abort(.notFound)
        }
        organization.queue.append(add.appointmentId)
        try await organization.update(on: req.db)
        return add
    }
    
    /// Adds a new appointment to unschedule queue
    func addAppointmentToUnscheduleQueue(req: Request) async throws -> OrganizationDTO.AddAppointmentToUnscheduleQueue {
        let add = try req.content.decode(OrganizationDTO.AddAppointmentToUnscheduleQueue.self)
        guard let organization = try await Organization.find(add.id, on: req.db) else {
            throw Abort(.notFound)
        }
        organization.unscheduleQueue.append(add.appointmentId)
        try await organization.update(on: req.db)
        return add
    }
    
    /// Removes the first appointment from queue
    func removeFirstAppointmentFromQueue(req: Request) async throws -> OrganizationDTO.RemoveFirstAppointmentFromQueue {
        let remove = try req.content.decode(OrganizationDTO.RemoveFirstAppointmentFromQueue.self)
        guard let organization = try await Organization.find(remove.id, on: req.db) else {
            throw Abort(.notFound)
        }
        guard !organization.queue.isEmpty else {
            throw Abort(.badRequest, reason: "Queue is empty")
        }
        organization.queue.removeFirst()
        try await organization.update(on: req.db)
        return remove
    }
    
    /// Removes the first appointment from unschedule queue
    func removeFirstAppointmentFromUnscheduleQueue(req: Request) async throws -> OrganizationDTO.RemoveFirstAppointmentFromUnscheduleQueue {
        let remove = try req.content.decode(OrganizationDTO.RemoveFirstAppointmentFromUnscheduleQueue.self)
        guard let organization = try await Organization.find(remove.id, on: req.db) else {
            throw Abort(.notFound)
        }
        guard !organization.unscheduleQueue.isEmpty else {
            throw Abort(.badRequest, reason: "Unschedule Queue is empty")
        }
        organization.unscheduleQueue.removeFirst()
        try await organization.update(on: req.db)
        return remove
    }
    
    /// Deletes the organization
    func delete(req: Request) async throws -> HTTPStatus {
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await organization.delete(on: req.db)
        return .ok
    }
}
