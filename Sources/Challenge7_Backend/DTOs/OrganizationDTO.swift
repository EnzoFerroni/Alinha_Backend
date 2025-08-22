//
//  OrganizationDTO.swift
//  Challenge7_Backend
//
//  Created by Enzo Ferroni on 19/08/25.
//

import Fluent
import Vapor

/// A DTO is a type that represents what a client should send or receive.
struct OrganizationDTO: Content {
    ///Org Atributes
    var id: UUID?
    var name: String?
    var token: String?
    var appointmentPlaces: [String]?
    var mentors: [User]?
    var availableMentors: [User]?
    var queue: [Appointment]?
    var unscheduleQueue: [Appointment]?
    
    /// Converts the organization DTO to an organizationType
    /// - Returns: Organization
    func toModel() -> Organization {
        let model = Organization()
        
        model.id = self.id
        if let id = self.id {
            model.id = id
        }
        if let name = self.name {
            model.name = name
        }
        if let token = self.token {
            model.token = token
        }
        if let appointmentPlaces = self.appointmentPlaces {
            model.appointmentPlaces = appointmentPlaces
        }
        if let mentors = self.mentors {
            model.mentors = mentors
        }
        if let availableMentors = self.availableMentors {
            model.availableMentors = availableMentors
        }
        if let queue = self.queue {
            model.queue = queue
        }
        if let unscheduleQueue = self.unscheduleQueue {
            model.unscheduleQueue = unscheduleQueue
        }
        
        return model
    }
}

///Updates the organization atributes
extension OrganizationDTO {
    struct UpdateName: Content {
        var name: String
    }
    
    struct UpdateAppointmentPlaces: Content {
        var appointmentPlaces: [String]
    }
    
    struct UpdateMentors: Content {
        var mentors: [User]
    }
    
    struct UpdateAvailableMentors: Content {
        var availableMentors: [User]
    }
    
    struct UpdateQueue: Content {
        var queue: [Appointment]
    }
    
    struct UpdateUnscheduleQueue: Content {
        var unscheduleQueue: [Appointment]
    }
    
    struct GetQueue: Content {
        var queue: [Appointment]
    }
    
    struct GetUnscheduleQueue: Content {
        var unscheduleQueue: [Appointment]
    }
    
    struct AddAppointmentToQueue: Content {
        var appointment: Appointment
    }
    
    struct AddAppointmentToUnscheduleQueue: Content {
        var appointment: Appointment
    }
    
    struct RemoveFirstAppointmentFromQueue: Content {
        var appointmentId: UUID
    }
    
    struct RemoveFirstAppointmentFromUnscheduleQueue: Content {
        var appointmentId: UUID
    }
}
