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

    /*Organization Atributes*/
    
    @OptionalParent(key: "userOrganizarion")
    var organizationUser: UserOrganization?

    
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

    @Field(key: "first_user")
    var first_id: User
    
    @Field(key: "appointmentPlaces")

    var appointmentPlaces: [String]
    
    @Field(key: "users")
    var users: [User.IDValue]
    
    @Field(key: "available_mentors")
    var availableMentors: [User.IDValue]
    
    @Field(key: "queue")
    var queue: [Appointment.IDValue]
    
    @Field(key: "unschedule_queue")
    var unscheduleQueue: [Appointment.IDValue]
    
//TODO:INIT 
    
    // MARK: - Public Methods
    
    /// Converts Organization model to DTO
    /// - Returns: OrganizationDTO with all model data
    func toDTO() -> OrganizationDTO {
        .init(
            id: id,
            name: name,
          first_user_id: first_id,
            token: token,
            appointmentPlaces: appointmentPlaces,
            users: users,
            availableMentors: availableMentors,
            queue: queue,
            unscheduleQueue: unscheduleQueue
        )

    }
}
