//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 19/08/25.
//

import Foundation
import Vapor
import Fluent

//MARK: - Enums

///Enumerates different types (permissions) of users
enum UserRole: String, Codable {
    case adm
    case mentor
    case student
}

///Enumerates differents types of user path of interest
enum UserPath: String, Codable {
    case design
    case code
    case undefined
}

//MARK: - User Model

final class User: Model, @unchecked Sendable{
    
    static let schema = "TB_users"
    
    /// Unique identifier for this user.
    @ID(key: .id)
    var id: UUID?
    
    /*User Atributes*/
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "role")
    var role: UserRole
    
    @Field(key: "path")
    var path: UserPath
    
    
    ///Class constructor
    init() {}
    init(id: UUID? = nil, name: String, email: String, password: String, role: UserRole, path: UserPath) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.path = path
    }
    
    func toDTO() -> UserDTO{
        .init(id: id,
              name: self.$name.value,
              email: self.$email.value,
              password: self.$password.value,
              role: self.$role.value,
              path: self.$path.value)
    }
    
}
