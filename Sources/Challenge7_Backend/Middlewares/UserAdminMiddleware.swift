import Vapor
import Fluent

struct AdminOnlyMiddleware: AsyncMiddleware {
    func respond(to req: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized, reason: "Not authenticated")
        }
        guard user.role == .adm else {
            throw Abort(.forbidden, reason: "Admins only")
        }
        return try await next.respond(to: req)
    }
}

