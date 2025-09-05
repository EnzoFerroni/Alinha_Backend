//
//  File.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 20/08/25.
//

import Fluent

struct CreateAppointment: AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.enum("path_appointment")
            .case("code")
            .case("design")
            .case("unknown")
            .create()
        
        let pathAppointment = try await database.enum("path_appointment").read()
        
        try await database.enum("type_appointment")
            .case("problem")
            .case("doubt")
            .create()
        
        let typeAppointment = try await database.enum("type_appointment").read()
        
        try await database.schema("TB_appointments")
            .id()
            /// The name of the mentor for the appointment.
            .field("mentor", .string, .required)
            /// The unique ID of the student, linked to TB_users table.
            .field("student_id", .uuid, .required, .references("TB_users", "id", onDelete: .cascade))
            /// A description of the appointment details.
            .field("description", .string, .required)
            /// The location where the appointment will take place.
            .field("appointmentPlace", .string, .required)
            /// Indicates if the appointment has been scheduled.
            .field("isScheduled", .bool, .required, .sql(.default(false)))
            /// Indicates if the mentor should call the student.
            .field("callStudent", .bool, .required, .sql(.default(false)))
            /// Marks if the appointment has been completed.
            .field("isDone", .bool, .required, .sql(.default(false)))
            /// The full name of the student for reference.
            .field("studentName", .string, .required)
            /// The device token used for sending notifications to the student.
            .field("deviceToken", . string, .required)
            /// The timestamp of when the appointment was created.
            .field("createdAt", .datetime)
            /// The type of the appointment, such as problem or doubt.
            .field("type", typeAppointment, .required)
            /// The path of the appointment, such as code, design, or unknown.
            .field("path", pathAppointment, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("TB_appointments").delete()
        try await database.enum("path_appointment").delete()
        try await database.enum("type_appointment").delete()
    }
}
