//
//  File.swift
//  Challenge7_Backend
//
//  Created by João Vitor Rocha Miranda on 28/08/25.
//

import Vapor
import Fluent

struct AdmMentorMiddleware: Middleware {
    func respond(to req: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        guard let user = req.auth.get(User.self) else {
            return req.eventLoop.future (error: Abort(.unauthorized, reason: "Not authenticated"))
        }
        guard user.role == .mentor || user.role == .adm else {
            return req.eventLoop.future (error: Abort(.forbidden, reason: "Admins only"))
        }
        return next.respond(to: req)
    }
}
