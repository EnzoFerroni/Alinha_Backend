import Vapor
import Fluent

struct AdminOnlyMiddleware: Middleware {
    func respond(to req: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        guard let user = req.auth.get(User.self), user.role == .adm else {
            return req.eventLoop.future(error: Abort(.unauthorized, reason: "Not authenticated"))
        }
        return next.respond(to: req)
    }
}
