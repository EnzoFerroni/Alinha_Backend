//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 25/08/25.
//

import Foundation
import Vapor
import Fluent

///Aux table that contains the relationship between the user and the org
final class UserOrganization: Model, @unchecked Sendable {
    static let schema = "RL_user_organization"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "org_id")
    var organization: Organization

    @Parent(key: "user_id")
    var user: User

    @Enum(key: "user_role")
    var user_role: UserRole

    init() {}
    init(id: UUID? = nil, orgID: Organization.IDValue, userID: User.IDValue, user_role: UserRole) {
        self.id = id
        self.$organization.id = orgID
        self.$user.id = userID
        self.user_role = user_role
    }

    func toDTO() -> UserOrganizationDTO {
        .init(
            id: self.id,
            org_id: self.$organization.id,
            user_id: self.$user.id,
            user_role: self.user_role
        )
    }
}
