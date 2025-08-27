import Vapor
import Fluent

struct UserAdminMiddleware: AsyncMiddleware {
    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        
        guard let actor = req.auth.get(User.self) else {
            throw Abort(.unauthorized, reason: "Not authenticated")
        }

        
        guard let orgIDStr = req.parameters.get("orgID"),
              let orgID = UUID(uuidString: orgIDStr) else {
            throw Abort(.badRequest, reason: "Missing or invalid orgID")
        }

       
        let qb: QueryBuilder<UserOrganization> = UserOrganization.query(on: req.db)

        let actorID = try actor.requireID()

        let isAdmin = try await qb
            .filter(\.$user.$id == actorID)
            .filter(\.$organization.$id == orgID)
            .filter(\.$user_role == .adm)
            .first() != nil

        guard isAdmin else {
            throw Abort(.forbidden, reason: "User is not admin of this organization")
        }

        return try await next.respond(to: req)
    }
}
