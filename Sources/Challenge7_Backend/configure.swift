import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import APNS
import VaporAPNS
import APNSCore

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .PATCH, .DELETE],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent]
    )
    
    let cors = CORSMiddleware(configuration: corsConfiguration)

    //MARK: APNS credentials — loaded from environment variables (never hardcode secrets)
    // Set APNS_PRIVATE_KEY (the .p8 contents), APNS_KEY_ID and APNS_TEAM_ID in the environment.
    if let apnsPrivateKey = Environment.get("APNS_PRIVATE_KEY"),
       let apnsKeyId = Environment.get("APNS_KEY_ID"),
       let apnsTeamId = Environment.get("APNS_TEAM_ID") {

        // Configure APNS using JWT authentication.
        let apnsConfig = APNSClientConfiguration(
            authenticationMethod: .jwt(
                privateKey: try .loadFrom(string: apnsPrivateKey),
                keyIdentifier: apnsKeyId,
                teamIdentifier: apnsTeamId
            ),
            environment: .development
        )
        app.apns.containers.use(
            apnsConfig,
            eventLoopGroupProvider: .shared(app.eventLoopGroup),
            responseDecoder: JSONDecoder(),
            requestEncoder: JSONEncoder(),
            as: .default
        )
    } else {
        app.logger.warning("APNS env vars not set (APNS_PRIVATE_KEY / APNS_KEY_ID / APNS_TEAM_ID) — APNS disabled.")
    }

    app.middleware.use(cors, at: .beginning)
    app.migrations.add(UserMigration())
    app.migrations.add(CreateAppointment())

    // register routes
    try routes(app)
}
