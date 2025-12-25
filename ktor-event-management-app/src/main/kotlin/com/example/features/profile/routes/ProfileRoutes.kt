package com.example.features.profile.routes

import com.example.core.exceptions.BadRequestException
import com.example.core.exceptions.ForbiddenException
import com.example.features.auth.middleware.authorize
import com.example.features.auth.utils.UserRole
import com.example.features.profile.controllers.ProfileControllers
import io.ktor.server.auth.*
import io.ktor.server.routing.*

fun Route.profileRoutes(profileController: ProfileControllers){
    route("/api/profile"){
        authenticate {
            get("/{id}") {
                val id = call.parameters["id"]?.toIntOrNull() ?: throw BadRequestException("Missing id.")
                if (!authorize(call, listOf(UserRole.USER, UserRole.ADMIN, UserRole.ORGANIZER), targetUserId = id)) {
                    throw ForbiddenException("You are not allowed to access this resource.")
                }

                profileController.getUserProfile(call)
            }

            get {
                if (!authorize(call,  listOf(UserRole.ADMIN))) {
                    throw ForbiddenException("You are not allowed to access this resource.")
                }
                profileController.getAllProfiles(call)
            }

            patch("/{id}") {
                val id = call.parameters["id"]?.toIntOrNull() ?: throw BadRequestException("Invalid or missing user id.")
                if (!authorize(call, listOf(UserRole.USER, UserRole.ADMIN, UserRole.ORGANIZER), targetUserId = id)) {
                    throw ForbiddenException("You are not allowed to access this resource.")
                }
                profileController.updateUserProfile(call)
            }

            delete("/{id}") {
                val id = call.parameters["id"]?.toIntOrNull() ?: throw BadRequestException("Missing id.")
                if (!authorize(call, listOf(UserRole.USER, UserRole.ADMIN, UserRole.ORGANIZER), targetUserId = id)) {
                    throw ForbiddenException("You are not allowed to update this profile.")
                }
                profileController.deleteUserProfile(call)
            }
        }
    }
}