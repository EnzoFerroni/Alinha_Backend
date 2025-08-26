//
//  OrganizationDTO.swift
//  Challenge7_Backend
//
//  Created by Enzo Ferroni on 19/08/25.
//

import Fluent
import Vapor

// MARK: - Main Organization DTO
/// Main DTO representing organization data for API responses
struct OrganizationDTO: Content {
    var id: UUID?
    var name: String?
    var token: String?
    var appointmentPlaces: [String]?
    var users: [UUID]?
    var availableMentors: [UUID]?
    var queue: [UUID]?
    var unscheduleQueue: [UUID]?
}

// MARK: - Request DTOs
extension OrganizationDTO {
    /// DTO for getting organization by ID
    struct GetByIdRequest: Content {
        var id: UUID
    }
    
    /// DTO for getting organization by token
    struct GetByTokenRequest: Content {
        var token: String
    }
    
    /// DTO for creating new organization
    struct CreateRequest: Content {
        var name: String
        var appointmentPlaces: [String]?
        var users: [UUID]?
        var availableMentors: [UUID]?
    }
    
    /// DTO for updating organization name
    struct UpdateNameRequest: Content {
        var id: UUID
        var name: String
    }
    
    /// DTO for updating appointment places
    struct UpdateAppointmentPlacesRequest: Content {
        var id: UUID
        var appointmentPlaces: [String]
    }
    
    /// DTO for updating organization users
    struct UpdateUsersRequest: Content {
        var id: UUID
        var users: [UUID]
    }
    
    /// DTO for updating available mentors
    struct UpdateAvailableMentorsRequest: Content {
        var id: UUID
        var availableMentors: [UUID]
    }
    
    /// DTO for adding appointment to queue
    struct AddAppointmentToQueueRequest: Content {
        var id: UUID
        var appointmentId: UUID
    }
    
    /// DTO for adding appointment to unschedule queue
    struct AddAppointmentToUnscheduleQueueRequest: Content {
        var id: UUID
        var appointmentId: UUID
    }
    
    /// DTO for removing appointment from queue (only needs org ID)
    struct RemoveFromQueueRequest: Content {
        var id: UUID
    }
}

// MARK: - Response DTOs
extension OrganizationDTO {
    /// Response DTO for queue operations
    struct QueueResponse: Content {
        var id: UUID
        var queue: [UUID]
    }
    
    /// Response DTO for unschedule queue operations
    struct UnscheduleQueueResponse: Content {
        var id: UUID
        var unscheduleQueue: [UUID]
    }
    
    /// Response DTO for appointment places
    struct AppointmentPlacesResponse: Content {
        var id: UUID
        var appointmentPlaces: [String]
    }
}
