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
    var mentor: String?
    var student: String?
    var appointmentPlace: UserPath?
    var appointmentCategory: AppointmentType?
    var isScheduled: Bool?
    var callStudent: Bool?
    var isDone: Bool?
    
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
        
        if let isScheduled = self.isScheduled {
            model.isScheduled = isScheduled
        }
        
        if let callStudent = self.callStudent {
            model.callStudent = callStudent
        }
        
        if let isDone = self.isDone {
            model.isDone = isDone
        }
    }
}
