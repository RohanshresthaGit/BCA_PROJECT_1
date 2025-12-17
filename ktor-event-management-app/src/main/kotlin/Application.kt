package com.example

import com.example.config.DatabaseFactory
import com.example.core.plugins.configureErrorHandling
//import com.example.core.plugins.configureErrorHandler
//import com.example.features.auth.databaseTable.UserDataSource
import com.example.core.plugins.configureRouting
import com.example.core.plugins.configureSecurity
import com.example.core.plugins.configureSerialization
import com.example.core.plugins.security.hashing.SHA256HashingService
import com.example.core.plugins.security.token.JwtTokenService
import com.example.core.plugins.security.token.TokenConfig
import com.example.features.auth.controllers.AuthController
//import com.example.features.auth.middleware.authMiddleware
import com.example.features.auth.models.User
import com.example.features.auth.repositories.UserRepository
import com.example.features.auth.services.AuthService
import com.example.features.auth.services.AuthServiceImpl
import com.example.features.profile.controllers.ProfileControllers
import com.example.features.profile.repositories.ProfileRepositoryImpl
import com.example.features.profile.services.ProfileService
import com.example.features.profile.services.ProfileServiceImpl
import io.ktor.server.application.*
import io.ktor.util.*


val UserKey = AttributeKey<String>("user")
fun main(args: Array<String>) {
    io.ktor.server.netty.EngineMain.main(args)
}

fun Application.module() {

    DatabaseFactory.init()
//    val userDataSource = UserDataSource(databaseFactory.database)
    val tokenService = JwtTokenService()
    val tokenConfig = TokenConfig(
        issuer = environment.config.property("jwt.issuer").getString(),
        audience = environment.config.property("jwt.audience").getString(),
        expiresIn = 365L * 1000L * 60L * 60L * 24L,
        secret = System.getenv("JWT_SECRET")
    )

    val hashingService = SHA256HashingService()

    val userRepository = UserRepository()
    val profileRepository = ProfileRepositoryImpl()

    val authService = AuthServiceImpl(userRepository, hashingService, tokenConfig)
    val profileService = ProfileServiceImpl(profileRepository)

    val authController = AuthController(authService)
    val profileController = ProfileControllers(profileService)

    // Ensure admin exists
    userRepository.ensureAdminExists(hashingService)
    configureSerialization()
    configureSecurity(tokenConfig)
    configureRouting(authController, profileController)
    configureErrorHandling()
//    authMiddleware(tokenConfig)
}
