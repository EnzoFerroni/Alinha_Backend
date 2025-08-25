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
    var organization: Organization.IDValue?
    /// Mentor user associated with the appointment.
    var mentor: User.IDValue?
    /// Student user associated with the appointment.
    var student: User.IDValue?
    /// Place where the appointment will occur.
    var appointmentPlace: String?
    /// Category of the appointment, based on user path.
    var appointmentCategory: UserPath?
    /// Type of the appointment (e.g., ddoubt, problem).
    var appointmentType: AppointmentType?
    /// Indicates if the appointment is scheduled.
    var isScheduled: Bool?
    /// Indicates if the student should be called for the appointment.
    var callStudent: Bool?
    /// Indicates if the appointment is done.
    var isDone: Bool?
    /// Date and time when the appointment was created.
    var createdAt: Date?
}

extension AppointmentDTO {
    /// DTO for updating the mentor of an appointment.
    struct UpdateMentor : Content {
        var appointmentId: UUID
        var mentor: User
    }
    /// DTO for updating the place of an appointment.
    struct UpdatePlace: Content {
        var appointmentPlace: String
    }
    /// DTO for updating the scheduled status of an appointment.
    struct UpdateScheduled : Content {
        var isScheduled: Bool
    }
    /// DTO for updating the callStudent status of an appointment.
    struct UpdateCallStudent : Content {
        var callStudent: Bool
    }
    /// DTO for updating the done status of an appointment.
    struct UpdateDone : Content {
        var isDone: Bool
    }
}
