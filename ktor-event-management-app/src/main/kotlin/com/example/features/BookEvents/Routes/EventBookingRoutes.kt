package com.example.features.BookEvents.Routes


import com.example.core.exceptions.BadRequestException
import com.example.core.utils.ApiResponse
import com.example.features.BookEvents.service.BookingService
import io.ktor.http.HttpStatusCode
import io.ktor.server.request.receive
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.bookingRoutes() {

    post("/api/events/book/{eventId}") {

        val body: Map<String, Int> = try {
            call.receive()
        } catch (e: Exception) {
            throw BadRequestException("Invalid User id.")
        }

        val userId = body["userId"]
            ?: throw BadRequestException("Invalid or Missing user id.")

        val eventId = call.parameters["eventId"]?.toIntOrNull()
            ?: throw BadRequestException("Invalid event ID")

        BookingService.bookEvent(userId, eventId)

        call.respond(HttpStatusCode.OK, ApiResponse(success = true, data = "Event booked successfully"))
    }

    get("/api/event/checkIsBooked/{eventId}"){

        val userId = call.request.queryParameters["userId"]?.toIntOrNull()
            ?: throw BadRequestException("Invalid or missing userId")

        val eventId = call.parameters["eventId"]?.toIntOrNull()
            ?: throw BadRequestException("Invalid event ID")

        BookingService.checkIsEventBooked(userId, eventId)
        call.respond(HttpStatusCode.OK, ApiResponse(success = true, data = "Event Already Booked"))
    }
}
