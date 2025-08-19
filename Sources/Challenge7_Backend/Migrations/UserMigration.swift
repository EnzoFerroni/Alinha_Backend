//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 19/08/25.
//

import Fluent

/// control system for your database, defining the change an undo it
struct UserMigration: AsyncMigration {
    ///  Make a change to the database.
    /// - Parameter database: where the data is stored
    func prepare(on database: any Database) async throws {
        try await database.enum("UserRole")
            .case("student")
            .case("mentor")
            .case("adm")
            .create()
        
        let userRole = try await database.enum("user_role").read()
        
        try await database.enum("user_path")
            .case("code")
            .case("design")
            .case("undefined")
            .create()
        
        let pathType = try await database.enum("user_path").read()
        
        try await database.schema("TB_users")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("role", userRole, .required)
            .field("path", pathType, .required)
            .unique(on: "email")
            .create()
    }
    
    /// Undo the change made in `prepare`, if possible.
    /// - Parameter database: where the data is stored
    func revert(on database: any Database) async throws {
        try await database.schema("users").delete()
    }
}
