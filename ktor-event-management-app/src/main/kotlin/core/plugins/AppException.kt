package com.example.core.plugins

import com.example.core.exceptions.AppException
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.response.*

@kotlinx.serialization.Serializable
data class ErrorResponse(
    val success: Boolean = false,
    val error: String?
)

fun Application.configureErrorHandling() {
    install(StatusPages) {
        exception<AppException> { call, cause ->
            call.respond(
                cause.statusCode,
                ErrorResponse(
                    success = false,
                    error = cause.message
                )
            )
        }

        exception<Throwable> { call, cause ->
            call.respond(
                HttpStatusCode.InternalServerError,
                ErrorResponse(
                    success = false,
                    error = cause.message
                )
            )
        }
    }
}