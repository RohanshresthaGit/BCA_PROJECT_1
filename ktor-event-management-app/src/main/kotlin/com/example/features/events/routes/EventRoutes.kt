package com.example.features.events.routes


import com.example.core.exceptions.BadRequestException
import com.example.core.exceptions.ForbiddenException
import com.example.features.auth.middleware.authorize
import com.example.features.auth.utils.UserRole
import com.example.features.events.controller.EventController
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.routing.*

fun Application.eventRoutes(controller: EventController) {
    routing {
        route("/api/events") {
            authenticate{
                post {
                    if (!authorize(call, listOf( UserRole.ORGANIZER))) {
                        throw ForbiddenException("You are not allowed to access this resource.")
                    }
                    controller.createEvent(call)
                }

                get {
                    if (!authorize(call, listOf(UserRole.ADMIN))) {
                        throw ForbiddenException("You are not allowed to access this resource.")
                    }
                    controller.getAllEvents(call)
                }

                get("/{id}") {
                    val id = call.parameters["id"]?.toIntOrNull() ?: throw BadRequestException("Missing id.")

                    if (!authorize(call, listOf(UserRole.USER, UserRole.ADMIN, UserRole.ORGANIZER))) {
                        throw ForbiddenException("You are not allowed to access this resource.")
                    }
                    controller.getEvent(call)
                }

                put("/{id}") {
                    val id = call.parameters["id"]?.toIntOrNull() ?: throw BadRequestException("Missing id.")
                    if (!authorize(call, listOf(UserRole.ORGANIZER))) {
                        throw ForbiddenException("You are not allowed to access this resource.")
                    }
                    controller.updateEvent(call)
                }

                delete("/{id}") {
                    val id = call.parameters["id"]?.toIntOrNull() ?: throw BadRequestException("Missing id.")
                    if (!authorize(call, listOf( UserRole.ADMIN, UserRole.ORGANIZER), targetUserId = id)) {
                        throw ForbiddenException("You are not allowed to access this resource.")
                    }
                    controller.deleteEvent(call)
                }
            }

        }
    }
}