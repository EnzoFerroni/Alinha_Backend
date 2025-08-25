//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 25/08/25.
//

import Vapor

final class UserOrganizationController{
    var userOrganizations: [UserOrganizationDTO]?
    
    func fetchUserOrg(req: Request) async throws{
        userOrganizations = try await UserOrganization.query(on: req.db).all().map { $0.toDTO() }
    }
    
    func delete(req: Request) async throws{
        //TODO: IMPLEMENT MIDDLEWARE
        guard let userOrg = try await UserOrganization.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await userOrg.delete(on: req.db)
    }
    
    
}
