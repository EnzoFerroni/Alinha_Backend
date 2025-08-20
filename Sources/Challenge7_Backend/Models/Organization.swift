//
//  Organization.swift
//  Challenge7_Backend
//
//  Created by Enzo Ferroni on 19/08/25.
//

import Fluent
import Vapor
import Foundation

final class Organization: Model, @unchecked Sendable {
    
    @Children(for: \.$organization)
    var users: [User]

    static let schema = "organizations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "token")
    var token: String
    
    @Field(key: "appointmentPlaces")
    var appointmentPlaces: [String]
    
    @Field(key: "mentors")
    var mentors: [String]
    
    @Field(key: "availableMentors")
    var availableMentors: [String]
    
    @Field(key: "queue")
    var queue: [String]
    
    @Field(key: "unscheduleQueue")
    var unscheduleQueue: [String]
    
    init() { }
    
    init(id: UUID? = nil, name: String, token: String, appointmentPlaces: [String], mentors: [String], availableMentors: [String], queue: [String], unscheduleQueue: [String]) {
        self.id = id
        self.name = name
        self.token = token
        self.appointmentPlaces = appointmentPlaces
        self.mentors = mentors
        self.availableMentors = availableMentors
        self.queue = queue
        self.unscheduleQueue = unscheduleQueue
    }
    
    func toDTO() -> OrganizationDTO {
        .init(
            id: self.id,
            name: self.$name.value,
            token: self.$token.value,
            appointmentPlaces: self.$appointmentPlaces.value,
            mentors: self.$mentors.value,
            availableMentors: self.$availableMentors.value,
            queue: self.$queue.value,
            unscheduleQueue: self.$unscheduleQueue.value,
        )
    }
}
