//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 19/08/25.
//

import Foundation
import Vapor
import Fluent
//MARK: - User Model

final class User: Model, @unchecked Sendable, Content{
    /// The schema name for the user table.
    static let schema = "TB_users"
    
    /// Unique identifier for the user.
    @ID(key: .id)
    var id: UUID?
    
    /*User Atributes*/
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "avaliable")
    var avaliable: Bool
    
    @Field(key: "password")
    var password: String
    
    @Enum(key: "role")
    var role: UserRole
    
    @Children(for: \Appointment.$student)
    var appointments: [Appointment]
    
    ///Class constructor
    init() {}
    init(id: UUID? = nil, name: String, email: String,avaliable: Bool, password: String, role: UserRole) {
        self.id = id
        self.name = name
        self.email = email
        self.avaliable = avaliable
        self.password = password
        self.role = role
    }
    
    /// Converts an user to UserDto
    /// - Returns: UserDto object
    func toDTO() -> UserDTO{
        .init(id: id,
              name: self.$name.value,
              email: self.$email.value,
              password: self.$password.value,
              avaliable: self.avaliable,
              role: self.$role.value)
    }
    
    /// What the frontEnd can "see"
    final class Public: Content, @unchecked Sendable{
        var id: UUID?
        var email: String
        
        init(id: UUID?, email: String) {
            self.id = id
            self.email = email
        }
    }
}

//MARK: - Authentication

extension User: ModelAuthenticatable {
    static var usernameKey: KeyPath<User, Field<String>>{
        \User.$email
    }
    
    static var passwordHashKey: KeyPath<User, Field<String>>{
        \User.$password
    }
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
    
    func convertToPublic()-> User.Public{
        return User.Public(id: id, email: email)
    }
}
