package com.example.core.plugins

import com.example.features.auth.controllers.AuthController
import com.example.features.auth.routes.authRoutes
import com.example.features.events.controller.EventController
import com.example.features.events.routes.eventRoutes
import com.example.features.profile.controllers.ProfileControllers
import com.example.features.profile.routes.profileRoutes
import io.ktor.server.application.*
import io.ktor.server.routing.*

fun Application.configureRouting(
    authController: AuthController,
    profileController: ProfileControllers,
    eventController: EventController,
) {
    routing {
        authRoutes(authController)
        profileRoutes(profileController)
        eventRoutes(eventController)
    }
}
