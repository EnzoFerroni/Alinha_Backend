//
//  Organization.swift
//  Challenge7_Backend
//
//  Created by Enzo Ferroni on 19/08/25.
//

import Fluent
import Vapor
import Foundation

// MARK: - Organization Model
/// Model representing an organization in the system
final class Organization: Model, @unchecked Sendable {
    static let schema = "TB_organizations" // SQL table name
    
    // MARK: - Properties
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "token")
    var token: String
    
    @OptionalParent(key: "appointment_id")
    var appointment: Appointment?
    
    @Field(key: "appointment_places")
    var appointmentPlaces: [String]
    
    @Field(key: "users")
    var users: [UUID]
    
    @Field(key: "available_mentors")
    var availableMentors: [UUID]
    
    @Field(key: "queue")
    var queue: [UUID]
    
    @Field(key: "unschedule_queue")
    var unscheduleQueue: [UUID]
    
    // MARK: - Initializers
    
    /// Empty initializer required by Fluent
    init() { }
    
    /// Complete initializer for Organization
    /// - Parameters:
    ///   - id: Organization unique identifier
    ///   - name: Organization name
    ///   - token: Access token for organization
    ///   - appointmentPlaces: Available appointment locations
    ///   - users: Array of user UUIDs belonging to organization
    ///   - availableMentors: Array of mentor UUIDs available for appointments
    ///   - queue: Queue of scheduled appointment UUIDs
    ///   - unscheduleQueue: Queue of unscheduled appointment UUIDs
    init(
        id: UUID? = nil,
        name: String,
        token: String,
        appointmentPlaces: [String],
        users: [UUID],
        availableMentors: [UUID],
        queue: [UUID],
        unscheduleQueue: [UUID]
    ) {
        self.id = id
        self.name = name
        self.token = token
        self.appointmentPlaces = appointmentPlaces
        self.users = users
        self.availableMentors = availableMentors
        self.queue = queue
        self.unscheduleQueue = unscheduleQueue
    }
    
    // MARK: - Public Methods
    
    /// Converts Organization model to DTO
    /// - Returns: OrganizationDTO with all model data
    func toDTO() -> OrganizationDTO {
        .init(
            id: id,
            name: name,
            token: token,
            appointmentPlaces: appointmentPlaces,
            users: users,
            availableMentors: availableMentors,
            queue: queue,
            unscheduleQueue: unscheduleQueue
        )
    }
}
