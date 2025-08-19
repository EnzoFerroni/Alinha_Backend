//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 19/08/25.
//

import Vapor
import Fluent

struct UserDTO: Content{
    var id: UUID?
    var name: String?
    var email: String?
    var password: String?
    var role: UserRole?
    var path: UserPath?
    
    func toModel() -> User{
        let model = User()
        
        model.id = self.id
        
        if let name = self.name{
            model.name = name
        }
        
        if let email = self.email{
            model.email = email
        }
        
        if let password = self.password{
            model.password = password
        }
        
        if let role = self.role{
            model.role = role
        }
        
        if let path = self.path{
            model.path = path
        }
        
        return model
    }
    
}
