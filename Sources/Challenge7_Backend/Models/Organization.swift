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
    static let schema = "TB_organizations"

    @Children(for: \.$organization)
    var members: [UserOrganization]

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "token")
    var token: String

    @OptionalParent(key: "appointment_id")
    var appointment: Appointment?

    @Field(key: "appointment_places")
    var appointment_places: [String]

    @Field(key: "first_user_id")
    var first_user_id: UUID

    @Field(key: "available_mentors")
    var availableMentors: [User.IDValue]

    @Field(key: "queue")
    var queue: [Appointment.IDValue]

    @Field(key: "unschedule_queue")
    var unscheduleQueue: [Appointment.IDValue]

    init() {}

    init(
        id: UUID? = nil,
        name: String,
        token: String,
        appointment: Appointment? = nil,
        appointment_places: [String],
        first_user_id: UUID,
        availableMentors: [User.IDValue],
        queue: [Appointment.IDValue],
        unscheduleQueue: [Appointment.IDValue]
    ) {
        self.id = id
        self.name = name
        self.token = token
        self.appointment = appointment
        self.appointment_places = appointment_places
        self.first_user_id = first_user_id
        self.availableMentors = availableMentors
        self.queue = queue
        self.unscheduleQueue = unscheduleQueue
    }

    func toDTO() -> OrganizationDTO {
        .init(
            id: id,
            name: name,
            first_user_id: first_user_id,
            token: token,
            appointment_places: appointment_places,
            availableMentors: availableMentors,
            queue: queue,
            unscheduleQueue: unscheduleQueue
        )
    }
}
