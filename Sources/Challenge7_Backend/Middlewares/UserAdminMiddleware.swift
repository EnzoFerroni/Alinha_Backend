import Vapor
import Fluent

///Middleware that filters if the requesting user is an ADM
struct AdminOnlyMiddleware: Middleware {
    func respond(to req: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        ///Check if the iser is logged
        guard let user = req.auth.get(User.self) else {
            return req.eventLoop.future (error: Abort(.unauthorized, reason: "Not authenticated"))
        }
        ///Check if the role is adm
        guard user.role == .adm else {
            return req.eventLoop.future (error: Abort(.forbidden, reason: "Admins only"))
        }
        return next.respond(to: req)
    }
}

