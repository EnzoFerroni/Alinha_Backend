//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 28/08/25.
//

import Vapor
import Fluent

struct AdmMentorMiddleware: AsyncMiddleware {
    func respond(to req: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized, reason: "Not authenticated")
        }
        guard user.role == .mentor || user.role == .adm else {
            throw Abort(.forbidden, reason: "Admins only")
        }
        return try await next.respond(to: req)
    }
}

