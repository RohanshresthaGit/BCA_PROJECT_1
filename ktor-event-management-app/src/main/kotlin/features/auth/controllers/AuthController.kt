package com.example.features.auth.controllers

import com.example.features.auth.models.User
import com.example.features.auth.models.dto.LoginRequest
import com.example.features.auth.models.dto.LoginResponse
import com.example.features.auth.models.dto.SignUpRequestModel
import com.example.features.auth.models.dto.SignUpResponseModel
import com.example.features.auth.services.AuthService
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*


class AuthController (
    private val authService: AuthService
){
    suspend fun register(call: ApplicationCall){
            try {
                val request: SignUpRequestModel = call.receive<SignUpRequestModel>()
                val result = authService.register(request)
                if (result.isSuccess) {
//                    val user = result.getOrNull()!!
                    call.respond(
                        HttpStatusCode.Created,
                        SignUpResponseModel(
                            success = true,
                            message = "Registration successful",
//                            user = User(
//                                id = user.id,
//                                email = user.email,
//                                username  = user.username,
//                                role = user.role,
//                            )
                        )
                    )
            } else {
                val error = result.exceptionOrNull()!!
                call.respond(
                    HttpStatusCode.BadRequest,
                    SignUpResponseModel(
                        success = false,
                        message = error.message ?: "Registration failed"
                    )
                )
            }

        } catch (e: Exception) {
            call.respond(
                HttpStatusCode.InternalServerError,
                SignUpResponseModel(
                    success = false,
                    message = "Server error: ${e.message}"
                )
            )
        }
    }

    suspend fun login(call: ApplicationCall){
        try{
            val request = call.receive<LoginRequest>()
            val result = authService.login(request)

            if (result.isSuccess) {
                val token = result.getOrNull()
                call.respond(
                    HttpStatusCode.OK,
                    LoginResponse(
                        success = true,
                        message = "Login successful",
                        token = token,

                    )
                )
            } else {
                val error = result.exceptionOrNull()!!
                call.respond(
                    HttpStatusCode.BadRequest,
                    LoginResponse(
                        success = false,
                        message = error.message ?: "Login failed"
                    )
                )
            }

        } catch (e: Exception) {
            call.respond(
                HttpStatusCode.InternalServerError,
                LoginResponse(
                    success = false,
                    message = "Server error: ${e.message}"
                )
            )
        }

    }
}