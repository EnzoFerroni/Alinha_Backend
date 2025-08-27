//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 27/08/25.
//

import Foundation
import Fluent

// MARK: - UserOrganization Migration
struct UserOrganizationMigration: AsyncMigration {
    
    // MARK: - Public Methods
    
    /// Creates the user-organization relation table in the database
    func prepare(on database: any Database) async throws {
        try await database.schema("RL_user_organization")
            .id()
            .field("org_id", .uuid, .required, .references("TB_organizations", "id", onDelete: .cascade))
            .field("user_id", .uuid, .required, .references("TB_users", "id", onDelete: .cascade))
            .field("user_role", .string, .required)
            .unique(on: "org_id", "user_id") 
            .create()
    }
    
    /// Removes the user-organization relation table from the database
    func revert(on database: any Database) async throws {
        try await database.schema("RL_user_organization").delete()
    }
}
