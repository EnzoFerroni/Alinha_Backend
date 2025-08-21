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
    var mentor: User?
    /// Student user associated with the appointment.
    var student: User?
    /// Place where the appointment will occur.
    var appointmentPlace: String?
    /// Category of the appointment, based on user path.
    var appointmentCategory: UserPath?
    /// Type of the appointment (e.g., Dúvida, Problema).
    var appointmentType: AppointmentType?
    /// Indicates if the appointment is scheduled.
    var isScheduled: Bool?
    /// Indicates if the student should be called for the appointment.
    var callStudent: Bool?
    /// Indicates if the appointment is done.
    var isDone: Bool?
    /// Date and time when the appointment was created.
    var createdAt: Date?
    
    /// Converts the DTO to an Appointment model instance.
    /// - Returns: An Appointment model populated with DTO data.
    func toModel() -> Appointment {
        let model = Appointment()
        model.id = self.id
        if let mentor = self.mentor {
            model.mentor = mentor
        }
        if let student = self.student {
            model.student = student
        }
        if let appointmentPlace = self.appointmentPlace {
            model.appointmentPlace = appointmentPlace
        }
        if let appointmentCategory = self.appointmentCategory {
            model.appointmentCategory = appointmentCategory
        }
        if let appointmentType = self.appointmentType {
            model.appointmentType = appointmentType
        }
        if let isScheduled = self.isScheduled {
            model.isScheduled = isScheduled
        }
        if let callStudent = self.callStudent {
            model.callStudent = callStudent
        }
        if let isDone = self.isDone {
            model.isDone = isDone
        }
        if let createdAt = self.createdAt {
            model.createdAt = createdAt
        }
        return model
    }
}

extension AppointmentDTO {
    /// DTO for updating the mentor of an appointment.
    struct UpdateMentor : Content {
        var id: UUID
        var mentor: User
    }
    /// DTO for updating the place of an appointment.
    struct UpdatePlace: Content {
        var id: UUID
        var appointmentPlace: String
    }
    /// DTO for updating the scheduled status of an appointment.
    struct UpdateScheduled : Content {
        var id: UUID
        var isScheduled: Bool
    }
    /// DTO for updating the callStudent status of an appointment.
    struct UpdateCallStudent : Content {
        var id: UUID
        var callStudent: Bool
    }
    /// DTO for updating the done status of an appointment.
    struct UpdateDone : Content {
        var id: UUID
        var isDone: Bool
    }
}
