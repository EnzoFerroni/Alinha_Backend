import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

//    app.get("test-push") { req async throws -> HTTPStatus in
//        try await req.apns.client.sendAlertNotification(alert, deviceToken: token)
//        return .ok
//    }
    
    try app.register(collection: UserController())
    try app.register(collection: AppointmentController())
}
