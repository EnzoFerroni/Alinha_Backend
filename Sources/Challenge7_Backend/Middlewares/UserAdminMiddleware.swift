import Vapor
import Fluent

// Middleware to check if the authenticated user is an admin of the specified organization
struct UserAdminMiddleware: AsyncMiddleware {
    func respond(to req: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        
        // Check if user is authenticated
        guard let actor = req.auth.get(User.self) else {
            throw Abort(.unauthorized, reason: "Not authenticated")
        }

        // Get orgID from request parameters and validate it as UUID
        guard let orgIDStr = req.parameters.get("orgID"),
              let orgID = UUID(uuidString: orgIDStr) else {
            throw Abort(.badRequest, reason: "Missing or invalid orgID")
        }
  
        // Prepare a query builder for UserOrganization
        let qb: QueryBuilder<UserOrganization> = UserOrganization.query(on: req.db)

        // Get the authenticated user's ID
        let actorID = try actor.requireID()

        // Check if the user is an admin of the same organization
        let isAdmin = try await qb
            .filter(\.$user.$id == actorID)
            .filter(\.$organization.$id == orgID)
            .filter(\.$user_role == .adm)
            .first() != nil

        // If user is not admin, forbid access
        guard isAdmin else {
            throw Abort(.forbidden, reason: "User is not admin of this organization")
        }

        // User is admin, proceed to next middleware or handler
        return try await next.respond(to: req)
    }
}
