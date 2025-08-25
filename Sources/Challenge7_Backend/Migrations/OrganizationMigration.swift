//
//  OrganizationMigration.swift
//  Challenge7_Backend
//
//  Created by Enzo Ferroni on 20/08/25.
//


import Fluent

struct OrganizationMigration: AsyncMigration {
    
    ///  Make a change to the database.
    /// - Parameter database: where the data is stored
    func prepare(on database: any Database) async throws {
        try await database.schema("TB_organizations")
            .id()
            .field("name", .string, .required)
            .field("token", .string, .required)
            .field("appointment_places", .array(of: .string), .required)
            .field("users", .array(of: .uuid), .required)
            .field("available_mentors", .array(of: .uuid), .required)
            .field("queue", .array(of: .uuid), .required)
            .field("unschedule_queue", .array(of: .uuid), .required)
        
            .unique(on: "token")
            .create()
    }
        ///Undo the change
        func revert(on database: any Database) async throws {
            try await database.schema("TB_organizations").delete()
        }
 ///TESTE
}
