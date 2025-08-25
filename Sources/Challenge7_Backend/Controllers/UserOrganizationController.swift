//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 25/08/25.
//

import Vapor

struct UserController: RouteCollection{
    func boot(routes: any RoutesBuilder) throws{
        let userControllers = routes.grouped("userControllers")
        userControllers.get(use: index)
        //userControllers.post(use: create)
        
        userControllers.group(":id"){userController in
            //.get(use: show)
            //userControllers.put(use: update)
            //userControllers.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [UserOrganizationDTO] {
        try await UserOrganization.query(on: req.db).all().map { $0.toDTO() }
    }
    
}
