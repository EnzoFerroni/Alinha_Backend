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
final class UserOrganization: Model, @unchecked Sendable{
    /// The schema name for the appointments table.
    static let schema = "RL_user_organization"
    
    /// Unique identifier for this relation.
    @ID(key: .id)
    var id: UUID?
    
    /// The org associated.
    @OptionalChild(for: \.$organizationUser)
    var org_id: Organization?
    
    /// The user associated.
    @OptionalChild(for: \.$userOrganization)
    var user_id: User?
    
    
    ///User role in this org
    @Enum(key: "user_role")
    var user_role: UserRole
    
    ///Class constructor
    init(){}
    init(id: UUID? = nil, org_id: Organization? = nil, user_id: User? = nil, user_role: UserRole) {
        self.id = id
        self.org_id = org_id
        self.user_id = user_id
        self.user_role = user_role
    }
    
    func toDTO() -> UserOrganizationDTO{
        return UserOrganizationDTO(
            id: self.id,
            org_id: self.org_id?.id,
            user_id: self.user_id?.id,
            user_role: self.user_role
        )
    }
}
