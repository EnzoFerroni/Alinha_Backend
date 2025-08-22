//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 21/08/25.
//

import Foundation
import Vapor

enum OrganizationPolicy {
    /// Admin can edit org atributes
    static func canEditOrganization(actor: User, org: Organization) -> Bool {
        if actor.role != .adm { return false }
        // return actor.$organization.id == org.id
        return true
    }
}
