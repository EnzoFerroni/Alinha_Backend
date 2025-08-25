//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 25/08/25.
//

import Vapor
import Fluent

// Data Transfer Object for Appointment, used for API communication.
struct UserOrganizationDTO: Content{
    var id: UUID?
    var org_id: Organization.IDValue?
    var user_id: User.IDValue?
    var user_role: UserRole?
}

extension UserOrganizationDTO{
    struct Create: Content{
        var org_id: Organization.IDValue
        var user_id: User.IDValue
        var user_role: UserRole
    }
}
