package com.example.core.plugins

import com.example.features.auth.controllers.AuthController
import com.example.features.auth.routes.authRoutes
import com.example.features.profile.controllers.ProfileControllers
import com.example.features.profile.routes.profileRoutes
import io.ktor.server.application.*
import io.ktor.server.routing.*

fun Application.configureRouting(
    authController: AuthController,
    profileController: ProfileControllers
) {
    routing {
        authRoutes(authController)
        profileRoutes(profileController)
    }
}
