//
//  File.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 19/08/25.
//

import Fluent
import Vapor

/// Data Transfer Object for Appointment, used for API communication.
struct AppointmentDTO: Content {
    /// Unique identifier for the appointment.
    var id: UUID?
    /// Mentor user associated with the appointment.
    var mentor: String?
    /// Student user associated with the appointment.
    var student: User.IDValue?
    ///Appointment description
    var description: String?
    /// Place where the appointment will occur.
    var appointmentPlace: String?
    /// Indicates if the appointment is scheduled.
    var isScheduled: Bool?
    /// Indicates if the student should be called for the appointment.
    var callStudent: Bool?
    /// Indicates if the appointment is done.
    var isDone: Bool?
    ///Student name associated with the appointment.
    var studentName: String?
    /// Date and time when the appointment was created.
    var createdAt: Date?
    ///Appointment type
    var type: TypeAppointment?
    ///Appointment path
    var path: PathAppointment?
}

extension AppointmentDTO {
    /// DTO for updating the place of an appointment.
    struct UpdatePlace: Content {
        var appointmentId: UUID
        var appointmentPlace: String
    }
    /// DTO for updating the scheduled status of an appointment.
    struct UpdateScheduled : Content {
        var appointmentId: UUID
        var isScheduled: Bool
    }
    /// DTO for updating the callStudent status of an appointment.
    struct UpdateCallStudent : Content {
        var appointmentId: UUID
        var callStudent: Bool
    }
    /// DTO for updating the done status of an appointment.
    struct UpdateDone : Content {
        var appointmentId: UUID
        var isDone: Bool
    }
    /// DTO for updating the done status of an appointment.
    struct UpdateMentor : Content {
        var appointmentId: UUID
        var mentor: String
    }
}
