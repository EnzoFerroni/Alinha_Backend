//
//  OrganizationMigration.swift
//  Challenge7_Backend
//
//  Created by Enzo Ferroni on 20/08/25.
//


import Fluent

struct OrganizationMigration: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema("TB_organizations")
            .id()
            .field("name", .string, .required)
            .field("token", .string, .required)
            .field("appointmentPlaces", .array(of: .string), .required)
            .field("mentors", .array(of: .string), .required)
            .field("availableMentors", .array(of: .string), .required)
            .field("queue", .array(of: .string), .required)
            .field("unscheduleQueue", .array(of: .string), .required)
        
            .unique(on: "token")
            .create()
    }
        func revert(on database: any Database) async throws {
            try await database.schema("organizations").delete()
        }

}
