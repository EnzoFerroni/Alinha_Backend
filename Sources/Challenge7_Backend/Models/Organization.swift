//
//  Organization.swift
//  Challenge7_Backend
//
//  Created by Enzo Ferroni on 19/08/25.
//

import Fluent
import Vapor
import Foundation


//MARK: - Organization Model
final class Organization: Model, @unchecked Sendable {
    /*Organization Atributes*/
    
    @OptionalParent(key: "userOrganizarion")
    var organizationUser: UserOrganization?
    
    static let schema = "TB_organizations" // Name that will be on SQL table
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "token")
    var token: String
    
    @Field(key: "first_user")
    var first_id: User
    
    @Field(key: "appointmentPlaces")
    var appointmentPlaces: [String]
    
    @Field(key: "mentors")
    var mentors: [User]
    
    @Field(key: "availableMentors")
    var availableMentors: [User]
    
    @Field(key: "queue")
    var queue: [Appointment]
    
    @Field(key: "unscheduleQueue")
    var unscheduleQueue: [Appointment]
    
    
    init() {}
    /// Initializes Organization class
    /// - Parameters:
    ///   - id: org ID
    ///   - name: org Name
    ///   - token: the user will access the org by this token
    ///   - appointmentPlaces: where the user will be attended
    ///   - mentors: All org mentors
    ///   - availableMentors: Mentors that can receeve new appointments
    ///   - queue: Queue of appointments
    ///   - unscheduleQueue: queue that does not have a mentor yet
    
    init(organizationUser: UserOrganization? = nil, id: UUID? = nil, name: String, token: String,first_id: User, appointmentPlaces: [String], mentors: [User], availableMentors: [User], queue: [Appointment], unscheduleQueue: [Appointment]) {
        self.organizationUser = organizationUser
        self.id = id
        self.name = name
        self.token = token
        self.first_id = first_id
        self.appointmentPlaces = appointmentPlaces
        self.mentors = mentors
        self.availableMentors = availableMentors
        self.queue = queue
        self.unscheduleQueue = unscheduleQueue
    }
    /// Turns the org into AorganizationDTO
    /// - Returns: AorganizationDTO
    func toDTO() -> OrganizationDTO {
        return OrganizationDTO(
            id: self.id,
            name: self.name,
            first_user_id: first_id,
            token: self.token,
            appointmentPlaces: self.appointmentPlaces,
            mentors: self.mentors,
            availableMentors: self.availableMentors,
            queue: self.queue,
            unscheduleQueue: self.unscheduleQueue)
    }
}
