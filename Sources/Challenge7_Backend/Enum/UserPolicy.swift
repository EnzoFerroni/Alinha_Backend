//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 21/08/25.
//

import Foundation
import Vapor

enum UserPolicy {
    /// adm can endit any user, but admins can only edit themself
    static func canEditUser(actor: User, target: User) -> Bool {
        if actor.role == .adm {
            // return actor.$organization.id == target.$organization.id
            return true
        }
        return actor.id == target.id
    }

    /// who can change the  user role
    static func canChangeRole(actor: User, target: User) -> Bool {
        return actor.role == .adm
    }
}
