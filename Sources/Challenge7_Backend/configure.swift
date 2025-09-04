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
    MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgDAiYwWQ5MYgYq5Wt
    rXP+d+Zj6fZjze2q2fJwFuL9kFigCgYIKoZIzj0DAQehRANCAAQKNFVi9Nc9PH6O
    N3ZHIER9nnxKqXVUoda8NN+j/d8JeDBIGor/dXXGoteKD1zgVYfijnX3Qs9IkwQ6
    NaSX0NIy
    -----END PRIVATE KEY-----
    """
    let apnsKeyId = "2R398ASNX6"      // 10-char Key ID
    let apnsTeamId = "2B49H9LV4C"     // 10-char Team ID
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
