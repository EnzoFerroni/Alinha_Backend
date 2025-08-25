//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 25/08/25.
//

import Vapor

final class UserOrganizationController{
    func index(req: Request) async throws -> [UserOrganizationDTO] {
        try await UserOrganization.query(on: req.db).all().map { $0.toDTO() }
    }
}
