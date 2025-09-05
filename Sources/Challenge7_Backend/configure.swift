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

    //MARK: APNS credentials
    //TODO: Turn into enviroment vars
    let apnsPrivateKey = """
    -----BEGIN PRIVATE KEY-----
    MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgOy6Nxulxh8PW9nkh
    U6mNzMaAlznNBQQIviL504c2tLagCgYIKoZIzj0DAQehRANCAASUYc7ETNV1C+Yq
    z26kU7JmcqwCWPy9tqW7u0fAH2hRDvhlhebuvDiUCkUmmSbrrLooaN5vx3Op8PcP
    5pyGv53D
    -----END PRIVATE KEY-----
    """
    let apnsKeyId = "6Z8D8QU468"      // 10-char Key ID
    let apnsTeamId = "32M6C7GWMQ"     // 10-char Team ID
    let apnsEnvironment: APNSEnvironment = .development

    // Configure APNS using JWT authentication.
    let apnsConfig = APNSClientConfiguration(
        authenticationMethod: .jwt(
            privateKey: try .loadFrom(string: apnsPrivateKey),
            keyIdentifier: apnsKeyId,
            teamIdentifier: apnsTeamId
        ),
        environment: apnsEnvironment
    )
    app.apns.containers.use(
        apnsConfig,
        eventLoopGroupProvider: .shared(app.eventLoopGroup),
        responseDecoder: JSONDecoder(),
        requestEncoder: JSONEncoder(),
        as: .default
    )
    
    app.middleware.use(cors, at: .beginning)
    app.migrations.add(UserMigration())
    app.migrations.add(CreateAppointment())

    // register routes
    try routes(app)
}
