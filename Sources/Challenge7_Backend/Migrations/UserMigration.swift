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
        try await database.enum("user_role")
            .case("student")
            .case("mentor")
            .case("adm")
            .create()
        
        let userRole = try await database.enum("user_role").read()
        
        try await database.schema("TB_users")
            .id()
            /// The full name of the user.
            .field("name", .string, .required)
            /// The email address of the user, must be unique.
            .field("email", .string, .required)
            /// The encrypted password of the user.
            .field("password", .string, .required)
            ///if the user is a mentor, can be avaliable or not
            .field("avaliable", .bool, .required, .sql(.default(false)))
            /// The role of the user, such as student, mentor, or adm.
            .field("role", userRole, .required)
            /// Ensures no two users have the same email address.
            .unique(on: "email")
            .create()
    }
    
    /// Undo the change made in `prepare`, if possible.
    /// - Parameter database: where the data is stored
    func revert(on database: any Database) async throws {
        try await database.schema("TB_users").delete()
    }
}
