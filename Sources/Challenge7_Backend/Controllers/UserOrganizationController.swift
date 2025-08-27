//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 25/08/25.
//
import Fluent
import Vapor

/// Controller responsible for managing UserOrganization relations
class UserOrganizationController{
    /// Fetches all the UserOrganizations
    func index(req: Request) async throws -> [UserOrganizationDTO] {
        try await UserOrganization.query(on: req.db).all().map { $0.toDTO() }
    }
    
    /// Creates a new user-organization relation from Organization and User models
    static func create(org: Organization, user: User, role: UserRole, database: any Database) async throws {
        // Delegate to the UUID-based overload
        try await create(orgID: try org.requireID(), userID: try user.requireID(), role: role, database: database)
    }
    
    /// Creates a new user-organization relation using raw UUIDs
    static func create(orgID: UUID, userID: UUID, role: UserRole, database: any Database) async throws {
        let userOrg = UserOrganization(
            orgID: orgID,
            userID: userID,
            user_role: role
        )
        try await userOrg.save(on: database)
    }
    
    /// Retrieves a specific UserOrganization by ID
    func show(req: Request) async throws -> UserOrganizationDTO {
        guard let userOrg = try await UserOrganization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return userOrg.toDTO()
    }
    
    /// Deletes a specific UserOrganization by ID
    func delete(req: Request) async throws -> HTTPStatus {
        guard let userOrg = try await UserOrganization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await userOrg.delete(on: req.db)
        return .ok
    }
}
