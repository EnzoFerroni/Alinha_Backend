import Vapor
import Fluent

struct AdminOnlyMiddleware: Middleware {
    func respond(to req: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        guard let user = req.auth.get(User.self) else {
            return req.eventLoop.future (error: Abort(.unauthorized, reason: "Not authenticated"))
        }
        guard user.role == .adm else {
            return req.eventLoop.future (error: Abort(.forbidden, reason: "Admins only"))
        }
        return next.respond(to: req)
    }
}

