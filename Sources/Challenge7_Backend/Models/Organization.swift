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
    
    static let schema = "TB_organizations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "token")
    var token: String
    
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
    
    init() { }
    
    init(id: UUID? = nil, name: String, token: String, appointmentPlaces: [String], mentors: [User], availableMentors: [User], queue: [Appointment], unscheduleQueue: [Appointment]) {
        
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
        return OrganizationDTO(
            id: self.id,
            name: self.name,
            token: self.token,
            appointmentPlaces: self.appointmentPlaces,
            mentors: self.mentors.map { $0.id?.uuidString ?? "" },
            availableMentors: self.availableMentors.map { $0.id?.uuidString ?? "" },
            queue: self.queue.map { $0.id?.uuidString ?? "" },
            unscheduleQueue: self.unscheduleQueue.map { $0.id?.uuidString ?? "" })
    }
}
