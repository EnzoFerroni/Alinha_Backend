//
//  File.swift
//  Challenge7_Backend
//
//  Created by Rafael Neves de Oliveira on 19/08/25.
//

import Fluent
import Vapor

struct AppointmentDTO: Content {
    var id: UUID?
    var mentor: User?
    var student: User?
    var appointmentPlace: String?
    var appointmentCategory: UserPath?
    var appointmentType: AppointmentType?
    var isScheduled: Bool?
    var callStudent: Bool?
    var isDone: Bool?
    var createdAt: Date?
    
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
    struct UpdateMentor : Content {
        var id: UUID
        var mentor: User
    }
    struct UpdatePlace: Content {
        var appointmentPlace: String
    }
    
    struct UpdateScheduled : Content {
        var isScheduled: Bool
    }
    
    struct UpdateCallStudent : Content {
        var callStudent: Bool
    }
    
    struct UpdateDone : Content {
        var isDone: Bool
    }
}
