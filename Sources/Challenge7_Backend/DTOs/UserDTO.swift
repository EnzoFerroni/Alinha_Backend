//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 19/08/25.
//

import Vapor
import Fluent

/// A DTO is a type that represents what a client should send or receive.
struct UserDTO: Authenticatable, Content {
    ///User Atributes
    var id: UUID?
    var name: String?
    var email: String?
    var password: String?
    var role: UserRole?
}

extension UserDTO {
    ///Body of post user requisition
    struct Create: Content {
        var name: String
        var email: String
        var password: String
        var confirmedPassword: String
        var role: UserRole
    }
    ///Body of patch updateName requisition
    struct UpdateNameRequest: Content, Decodable {
        var id: UUID
        var name: String
    }
    ///Body login requisition
    struct Login : Content {
        var email: String
        var password: String
    }
}

///All Authenticatable atributes
extension UserDTO.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension UserDTO.Login: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}
