//
//  OrganizationDTO.swift
//  Challenge7_Backend
//
//  Created by Enzo Ferroni on 19/08/25.
//

import Fluent
import Vapor

struct OrganizationDTO: Content {
    var id: UUID?
    var name: String?
    var token: String?
    var appointmentPlaces: [String]?
    var mentors: [User]?
    var availableMentors: [String]?
    var queue: [String]?
    var unscheduleQueue: [String]?
    
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

extension OrganizationDTO {
    struct UpdateName: Content {
        var id: UUID
        var name: String
    }
}

extension OrganizationDTO {
    struct UpdateAppointmentPlaces: Content {
        var id: UUID
        var appointmentPlaces: [String]
    }
}

extension OrganizationDTO {
    struct UpdateMentors: Content {
        var id: UUID
        var mentors: [String]
    }
}

extension OrganizationDTO {
    struct UpdateAvailableMentors: Content {
        var id: UUID
        var availableMentors: [String]
    }
}

extension OrganizationDTO {
    struct UpdateQueue: Content {
        var id: UUID
        var queue: [String]
    }
}

extension OrganizationDTO {
    struct UpdateUnscheduleQueue: Content {
        var id: UUID
        var unscheduleQueue: [String]
    }
}


