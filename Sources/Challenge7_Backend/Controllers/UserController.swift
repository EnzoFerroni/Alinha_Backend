//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 19/08/25.
//

import Vapor

struct UserController: RouteCollection{
    
    /// initializes all gates
    /// - Parameter routes: builds routes
    func boot(routes: any RoutesBuilder) throws{
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: create)
        
        users.group(":id"){user in
            user.get(use: show)
            user.delete(use: delete)
        }
        
        users.patch("updateName", use: updateName)
        
    }
    
    /// Fetches all users in data base
    /// - Parameter req: HTTP Request
    /// - Returns: A list of usersDTO
    func index(req: Request) async throws -> [UserDTO] {
        try await User.query(on: req.db).all().map { $0.toDTO() }
    }
    
    /// Creates a new user in data base
    /// - Parameter req: HTTP Request
    /// - Returns: userDTO
    @Sendable
    func create(req: Request) async throws -> User.Public {
        try UserDTO.Create.validate(content: req)
        let create = try req.content.decode(UserDTO.Create.self)
        guard create.password == create.confirmedPassword else{
            throw Abort(.badRequest, reason: "password doesn't match")
        }
        
        let user = try User(
            name: create.name,
            email: create.email,
            password: Bcrypt.hash(create.password),
            role: create.role,
            path: create.path
        )
        
        try await user.save(on: req.db)
        return user.convertToPublic()
        
    }
    
    /// Requets all users
    /// - Parameter req: HTTP Request
    /// - Returns: UserDTO
    func show(req: Request) async throws -> UserDTO {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user.toDTO()
    }
    
   
    
    /// Deletes an user object
    /// - Parameter req: HTTP Request
    /// - Returns: HTTP code
    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .ok
    }

}
