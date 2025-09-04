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

    //TODO: ATUALIZAR CREDENCIAIS E VALORES DOS ID
    // APNs credentials
    let apnsPrivateKey = """
    -----BEGIN PRIVATE KEY-----
    MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgHm5pSYg03FAnkaew
    brZd99yVPAe6PLPCIMJNzAjjfMygCgYIKoZIzj0DAQehRANCAAQxATK1YxQN1pQF
    FnOxRk88UFJWidQ5rSJK3L7B0USIHPrE7icZpihcYTnr2FhzM5JJhRp/Woaj6BIG
    8EqLy1VC
    -----END PRIVATE KEY-----
    """
    let apnsKeyId = "MUDAR"      // 10-char Key ID
    let apnsTeamId = "TAMBEM"     // 10-char Team ID
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
