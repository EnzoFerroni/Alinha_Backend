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
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    
    let cors = CORSMiddleware(configuration: corsConfiguration)

    let appleECP8PrivateKey = """
        -----BEGIN PRIVATE KEY-----
        MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg3dypZW1jdoObxEBg
        AeiSkeCgIJxVvL/UmdGIeh1NA4KgCgYIKoZIzj0DAQehRANCAAQnPyDqSJkQy7Ra
        OrtPnFWQ7s98R/MpVxs2rQVw1a48IUmLTfkXpfec1eMVBei+TJchrpP+lIOD48te
        yjI7bdEa
        -----END PRIVATE KEY-----
        """
    
    // Configure APNS using JWT authentication.
    let apnsConfig = APNSClientConfiguration(
        authenticationMethod: .jwt(
            privateKey: try .loadFrom(string: appleECP8PrivateKey),
            keyIdentifier: "6C9K22WRJY",
            teamIdentifier: "Carolina Sun Ramos Nantes de Castilho"
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
    
    // Custom Codable Payload
    struct Payload: Codable {
        let acme1: String
        let acme2: Int
    }
    // Create push notification Alert
    let dt = "70075697aa918ebddd64efb165f5b9cb92ce095f1c4c76d995b384c623a258bb"
    let payload = Payload(acme1: "hey", acme2: 2)
    let alert = APNSAlertNotification(
        alert: .init(
            title: .raw("Hello"),
            subtitle: .raw("This is a test from vapor/apns")
        ),
        expiration: .immediately,
        priority: .immediately,
        topic: "<#my topic#>",
        payload: payload
    )
    
    app.middleware.use(cors, at: .beginning)
    app.migrations.add(UserMigration())
    app.migrations.add(CreateAppointment())

    // register routes
    try routes(app)
}
