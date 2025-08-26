//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 25/08/25.
//
import Fluent
import Vapor

class UserOrganizationController{
    
    func index(req: Request) async throws -> [UserOrganizationDTO] {
        try await UserOrganization.query(on: req.db).all().map { $0.toDTO() }
    }
    
    
    func create(org: Organization, user: User, role: UserRole, database: any Database) async throws{
        
        let userOrg = UserOrganization(
            org_id: org,
            user_id: user,
            user_role: role
        )
        
        try await userOrg.save(on: database)
    }
    
    func show(req: Request) async throws -> UserOrganizationDTO {
        guard let userOrg = try await UserOrganization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return userOrg.toDTO()
    }
    
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let userOrg = try await UserOrganization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await userOrg.delete(on: req.db)
        return .ok
    }
}
