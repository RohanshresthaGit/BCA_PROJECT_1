//package com.example.core.plugins
//
//import com.example.features.auth.models.dto.SignUpResponseModel
//import io.ktor.http.*
//import io.ktor.server.application.*
//import io.ktor.server.plugins.*
//import io.ktor.server.plugins.statuspages.*
//import io.ktor.server.response.*
//import kotlinx.serialization.SerializationException
//
//fun Application.configureErrorHandler(){
//    install(StatusPages){
//        exception<SerializationException> { call, cause ->
//            call.respond(
//                status =  HttpStatusCode.BadRequest,
//                SignUpResponseModel(
//                    statusCode = HttpStatusCode.BadRequest.value,
//                    success = false,
//                    message = "Bad Request: $cause"
//                )
//            )
//        }
//
//        exception<BadRequestException> { call, cause ->
//            call.respond(
//                HttpStatusCode.BadRequest,
//                SignUpResponseModel(
//                    statusCode = HttpStatusCode.BadRequest.value,
//                    isSuccess = false,
//                    message = cause.message ?: "Bad Request"
//                )
//            )
//        }
//        exception<Throwable> { call, cause ->
//            // Log error for developers (optional)
//            cause.printStackTrace()
//
//            call.respond(
//                HttpStatusCode.InternalServerError,
//                SignUpResponseModel(
//                    statusCode = HttpStatusCode.InternalServerError.value,
//                    isSuccess = false,
//                    message = "Internal Server Error: $cause"
//                )
//            )
//        }
//
//    }
//}