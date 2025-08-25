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
    /// Org Attributes
    var id: UUID?
    var name: String?
    var token: String?
    var appointmentPlaces: [String]?
    var users: [UUID]?
    var availableMentors: [UUID]?
    var queue: [UUID]?
    var unscheduleQueue: [UUID]?

}

/// Updates the organization attributes
extension OrganizationDTO {
    struct UpdateName: Content {
        var id: UUID
        var name: String
    }
    
    struct UpdateAppointmentPlaces: Content {
        var id: UUID
        var appointmentPlaces: [String]
    }
    
    struct UpdateUsers: Content {
        var id: UUID
        var users: [UUID]
    }
    
    struct UpdateAvailableMentors: Content {
        var id: UUID
        var availableMentors: [UUID]
    }
    
    struct UpdateQueue: Content {
        var id: UUID
        var queue: [UUID]
    }
    
    struct UpdateUnscheduleQueue: Content {
        var id: UUID
        var unscheduleQueue: [UUID]
    }
    
    struct GetQueue: Content {
        var id: UUID
        var queue: [UUID]
    }
    
    struct GetUnscheduleQueue: Content {
        var id: UUID
        var unscheduleQueue: [UUID]
    }
    
    struct AddAppointmentToQueue: Content {
        var id: UUID
        var appointmentId: UUID
    }
    
    struct AddAppointmentToUnscheduleQueue: Content {
        var id: UUID
        var appointmentId: UUID
    }
    
    struct RemoveFirstAppointmentFromQueue: Content {
        var id: UUID
        var appointmentId: UUID
    }
    
    struct RemoveFirstAppointmentFromUnscheduleQueue: Content {
        var id: UUID
        var appointmentId: UUID
    }
    
    struct GetOrganizationByToken: Content {
        var token: String
    }
    
    struct GetAppointmentPlaces: Content {
        var id: UUID
        var appointmentPlaces: [String]
    }
}
