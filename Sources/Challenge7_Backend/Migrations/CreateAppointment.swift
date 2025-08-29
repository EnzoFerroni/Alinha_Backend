//
//  File.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 20/08/25.
//

import Fluent

struct CreateAppointment: AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.enum("type_appointment")
            .case("code")
            .case("design")
            .case("unknown")
            .create()
        
        let typeAppointment = try await database.enum("type_appointment").read()
        
        try await database.enum("path_appointment")
            .case("problem")
            .case("doubt")
            .create()
        
        let pathAppointment = try await database.enum("path_appointment").read()
        
        try await database.schema("TB_appointments")
            .id()
            .field("mentor", .string, .required)
            .field("student_id", .uuid, .required, .references("TB_users", "id", onDelete: .cascade))
            .field("description", .string, .required)
            .field("appointmentPlace", .string, .required)
            .field("isScheduled", .bool, .required, .sql(.default(false)))
            .field("callStudent", .bool, .required, .sql(.default(false)))
            .field("isDone", .bool, .required, .sql(.default(false)))
            .field("createdAt", .datetime)
            .field("type", typeAppointment, .required)
            .field("path", pathAppointment, .required)
        
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("TB_appointments").delete()
        try await database.enum("path_appointment").delete()
        try await database.enum("type_appointment").delete()
    }
}
