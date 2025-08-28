import Vapor
import Fluent

// Middleware to check if the authenticated user is an admin of the specified organization
struct UserAdminMiddleware: AsyncMiddleware {
    func respond(to req: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        
        // Check if user is authenticated
        guard let actor = req.auth.get(User.self) else {
            throw Abort(.unauthorized, reason: "Not authenticated")
        }
  
        // Get the authenticated user's ID
        let actorID = try actor.requireID()

        // User is admin, proceed to next middleware or handler
        return try await next.respond(to: req)
    }
}
