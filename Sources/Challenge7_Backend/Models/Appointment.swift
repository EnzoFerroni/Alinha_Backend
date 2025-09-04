//
//  Apointment.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 19/08/25.
//

import Fluent
import Vapor
import Foundation

/// Represents an appointment between a mentor and a student.
final class Appointment: Model, @unchecked Sendable {
    /// The schema name for the appointments table.
    static let schema = "TB_appointments"
    /// Unique identifier for an appointment.
    @ID(key: .id)
    var id: UUID?
    
    /// The student associated with the appointment.
    @Parent(key: "student_id")
    var student: User
    
    @Field(key: "mentor")
    var mentor: String
    
    @Field(key: "description")
    var description: String
    /// The place where the appointment will occur.
    @Field(key: "appointmentPlace")
    var appointmentPlace: String
    /// Indicates if the appointment is scheduled.
    @Field(key: "isScheduled")
    var isScheduled: Bool
    /// Indicates if the student should be called for the appointment.
    @Field(key: "callStudent")
    var callStudent: Bool
    /// Indicates if the appointment is done.
    @Field(key: "isDone")
    var isDone: Bool
    
    @Field(key: "studentName")
    var studentName: String
    /// The date and time when the appointment was created.
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Enum(key: "type")
    var type: TypeAppointment
    
    @Enum(key: "path")
    var path: PathAppointment
    
    /// Default initializer.
    init() { }
    
    /// Initializes a new Appointment instance.
    /// - Parameters:
    ///    - id: The unique identifier for the appointment.
    ///    - mentor: The mentor user.
    ///    - student: The student user.
    ///    - appointmentPlace: The place of the appointment.
    ///    - appointmentCategory: The category of the appointment.
    ///    - appointmentType: The type of the appointment.
    ///    - isScheduled: Whether the appointment is scheduled.
    ///    - callStudent: Whether to call the student.
    ///    - isDone: Whether the appointment is done.
    ///    - createdAt: The creation date of the appointment.
    
    init(id: UUID? = nil, mentor: String,description: String, appointmentPlace: String,student: User,  isScheduled: Bool, callStudent: Bool, isDone: Bool,studentName: String, createdAt: Date? = nil, type: TypeAppointment, path: PathAppointment) {
        self.id = id
        self.mentor = mentor
        self.student = student
        self.description = description
        self.appointmentPlace = appointmentPlace
        self.isScheduled = isScheduled
        self.callStudent = callStudent
        self.isDone = isDone
        self.studentName = studentName
        self.createdAt = createdAt
        self.type = type
        self.path = path
    }
    
    /// Converts the Appointment model to its corresponding DTO.
    /// - Returns: An AppointmentDTO representing the appointment.
    func toDTO() -> AppointmentDTO {
        .init (
            id: self.id,
            mentor: self.mentor,
            student: self.$student.id,
            description: self.description,
            appointmentPlace: self.$appointmentPlace.value,
            isScheduled: self.$isScheduled.value,
            callStudent: self.$callStudent.value,
            isDone: self.$isDone.value,
            studentName: self.$studentName.value,
            createdAt: self.$createdAt.value ?? Date.now,
            type: self.$type.value,
            path: self.$path.value
        )
    }
}
