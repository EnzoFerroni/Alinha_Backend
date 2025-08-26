//
//  OrganizationController.swift
//  Challenge7_Backend
//
//  Created by Enzo Ferroni on 19/08/25.
//

import Vapor

// MARK: - Organization Controller
struct OrganizationsController: RouteCollection {
    
    // MARK: - Route Registration
    /// Registers all organization routes
    /// - Parameter routes: Route builder for registering endpoints
    func boot(routes: any RoutesBuilder) throws {
        let organizations = routes.grouped("organizations")
        
        // GET routes
        organizations.get(use: index)
        organizations.post("getByToken", use: getByToken)
        organizations.post("getQueue", use: getQueue)
        organizations.post("getUnscheduleQueue", use: getUnscheduleQueue)
        organizations.post("getAppointmentPlaces", use: getAppointmentPlaces)
        
        // POST routes
        organizations.post("create", use: create)
        
        // PATCH routes
        organizations.patch("updateName", use: updateName)
        organizations.patch("updateAppointmentPlaces", use: updateAppointmentPlaces)
        organizations.patch("updateUsers", use: updateUsers)
        organizations.patch("updateAvailableMentors", use: updateAvailableMentors)
        organizations.patch("addAppointmentToQueue", use: addAppointmentToQueue)
        organizations.patch("addAppointmentToUnscheduleQueue", use: addAppointmentToUnscheduleQueue)
        organizations.patch("removeFirstAppointmentFromQueue", use: removeFirstAppointmentFromQueue)
        organizations.patch("removeFirstAppointmentFromUnscheduleQueue", use: removeFirstAppointmentFromUnscheduleQueue)
        
        // Routes with ID in URL
        organizations.group(":id") { organization in
            organization.get(use: show)
            organization.delete(use: delete)
        }
    }
    
    // MARK: - Public Methods
    
    /// Fetches all organizations
    /// - Parameter req: HTTP request
    /// - Returns: Array of organization DTOs
    func index(req: Request) async throws -> [OrganizationDTO] {
        try await Organization.query(on: req.db).all().map { $0.toDTO() }
    }
    
    /// Creates a new organization
    /// - Parameter req: HTTP request with organization data
    /// - Returns: Created organization DTO
    func create(req: Request) async throws -> OrganizationDTO {
        let createRequest = try req.content.decode(OrganizationDTO.CreateRequest.self)
        
        let organization = Organization(
            name: createRequest.name,
            token: generateToken(),
            appointmentPlaces: createRequest.appointmentPlaces ?? [],
            users: createRequest.users ?? [],
            availableMentors: createRequest.availableMentors ?? [],
            queue: [],
            unscheduleQueue: []
        )
        
        try await organization.save(on: req.db)
        return organization.toDTO()
    }
    
    /// Fetches organization by unique ID (URL parameter)
    /// - Parameter req: HTTP request with ID in URL
    /// - Returns: Organization DTO
    func show(req: Request) async throws -> OrganizationDTO {
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        return organization.toDTO()
    }
    
    /// Fetches organization by token
    /// - Parameter req: HTTP request with token in body
    /// - Returns: Organization DTO
    func getByToken(req: Request) async throws -> OrganizationDTO {
        let tokenRequest = try req.content.decode(OrganizationDTO.GetByTokenRequest.self)
        
        guard let organization = try await Organization.query(on: req.db)
            .filter(\.$token, .equal, tokenRequest.token)
            .first() else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        return organization.toDTO()
    }
    
    /// Fetches organization queue
    /// - Parameter req: HTTP request with organization ID in body
    /// - Returns: Queue response DTO
    func getQueue(req: Request) async throws -> OrganizationDTO.QueueResponse {
        let getRequest = try req.content.decode(OrganizationDTO.GetByIdRequest.self)
        
        guard let organization = try await Organization.find(getRequest.id, on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        return OrganizationDTO.QueueResponse(id: organization.id!, queue: organization.queue)
    }
    
    /// Fetches organization unschedule queue
    /// - Parameter req: HTTP request with organization ID in body
    /// - Returns: Unschedule queue response DTO
    func getUnscheduleQueue(req: Request) async throws -> OrganizationDTO.UnscheduleQueueResponse {
        let getRequest = try req.content.decode(OrganizationDTO.GetByIdRequest.self)
        
        guard let organization = try await Organization.find(getRequest.id, on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        return OrganizationDTO.UnscheduleQueueResponse(id: organization.id!, unscheduleQueue: organization.unscheduleQueue)
    }
    
    /// Fetches organization appointment places
    /// - Parameter req: HTTP request with organization ID in body
    /// - Returns: Appointment places response DTO
    func getAppointmentPlaces(req: Request) async throws -> OrganizationDTO.AppointmentPlacesResponse {
        let getRequest = try req.content.decode(OrganizationDTO.GetByIdRequest.self)
        
        guard let organization = try await Organization.find(getRequest.id, on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        return OrganizationDTO.AppointmentPlacesResponse(id: organization.id!, appointmentPlaces: organization.appointmentPlaces)
    }
    
    /// Updates organization name
    /// - Parameter req: HTTP request with ID and new name in body
    /// - Returns: Organization DTO
    func updateName(req: Request) async throws -> OrganizationDTO {
        let updateRequest = try req.content.decode(OrganizationDTO.UpdateNameRequest.self)
        
        guard let organization = try await Organization.find(updateRequest.id, on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        organization.name = updateRequest.name
        try await organization.update(on: req.db)
        return organization.toDTO()
    }
    
    /// Updates organization appointment places
    /// - Parameter req: HTTP request with ID and new appointment places in body
    /// - Returns: Organization DTO
    func updateAppointmentPlaces(req: Request) async throws -> OrganizationDTO {
        let updateRequest = try req.content.decode(OrganizationDTO.UpdateAppointmentPlacesRequest.self)
        
        guard let organization = try await Organization.find(updateRequest.id, on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        organization.appointmentPlaces = updateRequest.appointmentPlaces
        try await organization.update(on: req.db)
        return organization.toDTO()
    }
    
    /// Updates organization users
    /// - Parameter req: HTTP request with ID and new users in body
    /// - Returns: Organization DTO
    func updateUsers(req: Request) async throws -> OrganizationDTO {
        let updateRequest = try req.content.decode(OrganizationDTO.UpdateUsersRequest.self)
        
        guard let organization = try await Organization.find(updateRequest.id, on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        organization.users = updateRequest.users
        try await organization.update(on: req.db)
        return organization.toDTO()
    }
    
    /// Updates organization available mentors
    /// - Parameter req: HTTP request with ID and new available mentors in body
    /// - Returns: Organization DTO
    func updateAvailableMentors(req: Request) async throws -> OrganizationDTO {
        let updateRequest = try req.content.decode(OrganizationDTO.UpdateAvailableMentorsRequest.self)
        
        guard let organization = try await Organization.find(updateRequest.id, on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        organization.availableMentors = updateRequest.availableMentors
        try await organization.update(on: req.db)
        return organization.toDTO()
    }
    
    /// Adds appointment to organization queue
    /// - Parameter req: HTTP request with organization ID and appointment ID in body
    /// - Returns: Queue response DTO
    func addAppointmentToQueue(req: Request) async throws -> OrganizationDTO.QueueResponse {
        let addRequest = try req.content.decode(OrganizationDTO.AddAppointmentToQueueRequest.self)
        
        guard let organization = try await Organization.find(addRequest.id, on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        organization.queue.append(addRequest.appointmentId)
        try await organization.update(on: req.db)
        
        return OrganizationDTO.QueueResponse(id: organization.id!, queue: organization.queue)
    }
    
    /// Adds appointment to organization unschedule queue
    /// - Parameter req: HTTP request with organization ID and appointment ID in body
    /// - Returns: Unschedule queue response DTO
    func addAppointmentToUnscheduleQueue(req: Request) async throws -> OrganizationDTO.UnscheduleQueueResponse {
        let addRequest = try req.content.decode(OrganizationDTO.AddAppointmentToUnscheduleQueueRequest.self)
        
        guard let organization = try await Organization.find(addRequest.id, on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        organization.unscheduleQueue.append(addRequest.appointmentId)
        try await organization.update(on: req.db)
        
        return OrganizationDTO.UnscheduleQueueResponse(id: organization.id!, unscheduleQueue: organization.unscheduleQueue)
    }
    
    /// Removes first appointment from organization queue
    /// - Parameter req: HTTP request with organization ID in body
    /// - Returns: Queue response DTO
    func removeFirstAppointmentFromQueue(req: Request) async throws -> OrganizationDTO.QueueResponse {
        let removeRequest = try req.content.decode(OrganizationDTO.RemoveFromQueueRequest.self)
        
        guard let organization = try await Organization.find(removeRequest.id, on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        guard !organization.queue.isEmpty else {
            throw Abort(.badRequest, reason: "Queue is empty")
        }
        
        organization.queue.removeFirst()
        try await organization.update(on: req.db)
        
        return OrganizationDTO.QueueResponse(id: organization.id!, queue: organization.queue)
    }
    
    /// Removes first appointment from organization unschedule queue
    /// - Parameter req: HTTP request with organization ID in body
    /// - Returns: Unschedule queue response DTO
    func removeFirstAppointmentFromUnscheduleQueue(req: Request) async throws -> OrganizationDTO.UnscheduleQueueResponse {
        let removeRequest = try req.content.decode(OrganizationDTO.RemoveFromQueueRequest.self)
        
        guard let organization = try await Organization.find(removeRequest.id, on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        guard !organization.unscheduleQueue.isEmpty else {
            throw Abort(.badRequest, reason: "Unschedule queue is empty")
        }
        
        organization.unscheduleQueue.removeFirst()
        try await organization.update(on: req.db)
        
        return OrganizationDTO.UnscheduleQueueResponse(id: organization.id!, unscheduleQueue: organization.unscheduleQueue)
    }
    
    /// Deletes organization (URL parameter)
    /// - Parameter req: HTTP request with ID in URL
    /// - Returns: HTTP status
    func delete(req: Request) async throws -> HTTPStatus {
        guard let organization = try await Organization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "Organization not found")
        }
        
        try await organization.delete(on: req.db)
        return .noContent
    }
    
    // MARK: - Private Methods
    
    /// Generates a random 6-digit token for organization access
    /// - Returns: 6-digit numeric string
    private func generateToken() -> String {
        let characters = "0123456789"
        return String((0..<6).map { _ in characters.randomElement()! })
    }
}
