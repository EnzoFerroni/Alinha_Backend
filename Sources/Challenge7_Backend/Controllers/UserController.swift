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
            user.put(use: update)
            user.delete(use: delete)
        }
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
            throw Abort(.badRequest, reason: "Wrong Password!")
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
    
    /// Creates user updating gate
    /// - Parameter req: HTTP Request
    /// - Returns: userDTO
    func update(req: Request) async throws -> UserDTO {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedUser = try req.content.decode(User.self)
        
        user.name = updatedUser.name
        user.email = updatedUser.email
        user.password = updatedUser.password
        user.path = updatedUser.path
        user.role = updatedUser.role
        
        try await user.save(on: req.db)
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
    
    
    // MARK: - Admin

        func adminShowUser(req: Request) async throws -> UserDTO {
            let me = try req.auth.require(User.self)
            let target = try await findUser(req)

            guard UserPolicy.canEditUser(actor: me, target: target) else {
                throw Abort(.forbidden)
            }
            return target.toDTO()
        }

        struct UserAdminUpdateDTO: Content {
            var name: String?
            var email: String?
            var path: UserPath?
            var role: UserRole? 
        }

        func adminUpdateUser(req: Request) async throws -> UserDTO {
            let me = try req.auth.require(User.self)
            let target = try await findUser(req)
            let body = try req.content.decode(UserAdminUpdateDTO.self)

            guard UserPolicy.canEditUser(actor: me, target: target) else {
                throw Abort(.forbidden)
            }

            if let name = body.name { target.name = name }
            if let email = body.email { target.email = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
            if let path = body.path { target.path = path }
            if let role = body.role {
                guard UserPolicy.canChangeRole(actor: me, target: target) else {
                    throw Abort(.forbidden, reason: "Only admin can change user role.")
                }
                target.role = role
            }

            try await target.update(on: req.db)
            return target.toDTO()
        }

        func adminDeleteUser(req: Request) async throws -> HTTPStatus {
            let me = try req.auth.require(User.self)
            let target = try await findUser(req)

            guard UserPolicy.canEditUser(actor: me, target: target) else {
                throw Abort(.forbidden)
            }

            try await target.delete(on: req.db)
            return .ok
        }

        // MARK: - Helpers

        private func findUser(_ req: Request) async throws -> User {
            guard let idStr = req.parameters.get("id"),
                  let uuid = UUID(uuidString: idStr),
                  let user = try await User.find(uuid, on: req.db) else {
                throw Abort(.notFound)
            }
            return user
        }
    
}
