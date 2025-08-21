//
//  File.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 20/08/25.
//

import Fluent

struct CreateAppointment: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.enum("appointment_type")
            .case("Dúvida")
            .case("Problema")
            .create()
        let appointmentType = try await database.enum("appointment_type").read()
        
        let userPath = try await database.enum("user_path").read()
        
        try await database.schema("TB_appointments")
            .id()
            .field("mentor_id", .uuid, .references("TB_users", "id"))
            .field("student_id", .uuid, .required, .references("TB_users", "id"))
            .field("appointmentPlace", .string)
            .field("appointmentCategory", userPath, .required)
            .field("appointmentType", appointmentType, .required)
            .field("isScheduled", .bool)
            .field("callStudent", .bool)
            .field("isDone", .bool)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("TB_appointments").delete()
    }
}
