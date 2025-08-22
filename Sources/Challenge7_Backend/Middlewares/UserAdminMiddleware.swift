import Vapor

///Midaware that garantees that the user is an adm
struct UserAdminMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        guard let user = request.auth.get(User.self), user.role == .adm else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
        return next.respond(to: request)
    }
}
