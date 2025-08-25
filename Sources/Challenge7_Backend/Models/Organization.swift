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
    static let schema = "TB_organizations" // Name that will be on SQL table
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "token")
    var token: String
    
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
    
    init() { }
    
    /// Initializes Organization class
    /// - Parameters:
    ///   - id: org ID
    ///   - name: org Name
    ///   - token: the user will access the org by this token
    ///   - appointmentPlaces: where the user will be attended
    ///   - users: All org users UUIDs
    ///   - availableMentors: Mentors that can receive new appointments UUIDs
    ///   - queue: Queue of appointment UUIDs
    ///   - unscheduleQueue: queue that does not have a mentor yet UUIDs
    init(id: UUID? = nil, name: String, token: String, appointmentPlaces: [String], users: [UUID], availableMentors: [UUID], queue: [UUID], unscheduleQueue: [UUID]) {
        self.id = id
        self.name = name
        self.token = token
        self.appointmentPlaces = appointmentPlaces
        self.users = users
        self.availableMentors = availableMentors
        self.queue = queue
        self.unscheduleQueue = unscheduleQueue
    }
    
    /// Turns the org into OrganizationDTO
    /// - Returns: OrganizationDTO
    func toDTO() -> OrganizationDTO {
        .init(id: id,
              name: name,
              token: token,
              appointmentPlaces: appointmentPlaces,
              users: users,
                availableMentors: availableMentors,
                queue: queue,
                unscheduleQueue: unscheduleQueue)
    }
}
