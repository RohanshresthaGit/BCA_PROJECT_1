package com.example.features.auth.routes

import com.example.features.auth.controllers.AuthController

import io.ktor.server.routing.*

fun Route.authRoutes(authController: AuthController){
    route("/api/auth"){
        post("/signup") {
            authController.register(call)
        }

        post("/login"){
            authController.login(call)
        }
    }
}