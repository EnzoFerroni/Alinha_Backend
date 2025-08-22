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
    /// The mentor associated with the appointment.
    @Field(key: "mentor_id")
    var mentor: User
    /// The student associated with the appointment.
    @Field(key: "student_id")
    var student: User
    /// The place where the appointment will occur.
    @Field(key: "appointmentPlace")
    var appointmentPlace: String
    /// The category of the appointment, based on user path.
    @Enum(key: "appointmentCategory")
    var appointmentCategory: UserPath
    /// The type of the appointment (e.g., ddoubt, problem).
    @Enum(key: "appointmentType")
    var appointmentType: AppointmentType
    /// Indicates if the appointment is scheduled.
    @Boolean(key: "isScheduled")
    var isScheduled: Bool
    /// Indicates if the student should be called for the appointment.
    @Boolean(key: "callStudent")
    var callStudent: Bool
    /// Indicates if the appointment is done.
    @Boolean(key: "isDone")
    var isDone: Bool
    /// The date and time when the appointment was created.
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
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
    init(id: UUID? = nil, mentor: User, student: User, appointmentPlace: String, appointmentCategory: UserPath, appointmentType: AppointmentType, isScheduled: Bool, callStudent: Bool, isDone: Bool, createdAt: Date) {
        self.id = id
        self.mentor = mentor
        self.student = student
        self.appointmentPlace = appointmentPlace
        self.appointmentCategory = appointmentCategory
        self.isScheduled = false
        self.callStudent = false
        self.isDone = false
        self.createdAt = Date.now
    }
    
    /// Converts the Appointment model to its corresponding DTO.
    /// - Returns: An AppointmentDTO representing the appointment.
    func toDTO() -> AppointmentDTO {
        .init (
            id: self.id,
            mentor: self.$mentor.value,
            student: self.$student.value,
            appointmentPlace: self.$appointmentPlace.value,
            appointmentCategory: self.$appointmentCategory.value,
            appointmentType: self.$appointmentType.value,
            isScheduled: self.$isScheduled.value,
            callStudent: self.$callStudent.value,
            isDone: self.$isDone.value,
            createdAt: self.$createdAt.value ?? Date.now
        )
    }
}
