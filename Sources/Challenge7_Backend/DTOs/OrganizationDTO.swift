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
    var mentors: [String]?
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
        var name: String
    }

    struct UpdateAppointmentPlaces: Content {
        var appointmentPlaces: [String]
    }

    struct UpdateMentors: Content {
        var mentors: [String]
    }

    struct UpdateAvailableMentors: Content {
        var availableMentors: [String]
    }

    struct UpdateQueue: Content {
        var queue: [String]
    }

    struct UpdateUnscheduleQueue: Content {
        var unscheduleQueue: [String]
    }

    struct GetQueue: Content {
        var queue: [String]
    }

    struct GetUnscheduleQueue: Content {
        var unscheduleQueue: [String]
    }
}
