package com.example.features.profile.controllers

import UserProfile
import com.example.core.exceptions.BadRequestException
import com.example.core.exceptions.InternalServerErrorException
import com.example.core.exceptions.NotFoundException
import com.example.core.utils.ApiResponse
import com.example.features.auth.middleware.authorize
import com.example.features.auth.utils.UserRole
import com.example.features.profile.services.ProfileService
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.respond
import io.ktor.utils.io.*
import io.ktor.utils.io.core.*
import kotlinx.io.readByteArray


class ProfileControllers(private val profileService: ProfileService) {
    suspend fun getUserProfile(call: ApplicationCall){
        try {
            val id = call.parameters["id"]?.toIntOrNull()
                ?: throw BadRequestException("Invalid or missing Id.")

            val result = profileService.getUserProfile(id)

            result.fold(
                onSuccess = { profile ->
                    call.respond(HttpStatusCode.OK, profile)
                },
                onFailure = { error ->
                    throw NotFoundException(message = error.message ?: "User not found",)
                }
            )
        } catch (e: Exception) {
            throw InternalServerErrorException(message = e.message ?: "Something went wrong.")
        }
    }

    suspend fun getAllProfiles(call: ApplicationCall) {
        if (!authorize(call, listOf(UserRole.ADMIN))) return
        profileService.getAllProfiles()
            .onSuccess { profiles ->
                call.respond(
                    HttpStatusCode.OK,
                    ApiResponse(success = true, data = profiles)
                )
            }
            .onFailure { error ->
                throw InternalServerErrorException(message = error.message  ?: "Internal serer error.")
            }
    }

    suspend fun updateUserProfile(call: ApplicationCall) {
        var fullName: String? = null
        var email: String? = null
        var phone: String? = null
        var gender: String? = null
        var eventsAttended: Int? = null

        var photoBytes: ByteArray? = null
        var photoFileName: String? = null

        val id = call.parameters["id"]?.toIntOrNull()
            ?: throw BadRequestException("Invalid or missing id.")

        val multipart = call.receiveMultipart()
        multipart.forEachPart { part ->
            when (part) {
                is PartData.FormItem -> {
                    when (part.name) {
                        "fullName" -> fullName = part.value
                        "email" -> email = part.value
                        "phoneNumber" -> phone = part.value
                        "gender" -> gender = part.value
                        "eventsAttended" -> eventsAttended = part.value.toIntOrNull()
                    }
                }

                is PartData.FileItem -> {
                    if (part.name == "profilePhoto") {
                        photoBytes = part.provider().readRemaining().readByteArray()
                        photoFileName = part.originalFileName
                    }
                }

                else -> {}
            }
            part.dispose()
        }

        val updateUser = UserProfile(
            fullName = fullName,
            email = email,
            phone = phone,
            gender = gender,
            eventsAttended = eventsAttended
        )

        if (updateUser == UserProfile() && photoBytes == null) {
            throw BadRequestException("No fields provided to update.")
        }

        // Pass DTO + optional photo to service
        profileService.updateUserProfile(id, updateUser, photoBytes, photoFileName)
            .onSuccess {
                call.respond(
                    HttpStatusCode.OK,
                    ApiResponse(success = true, data = null, message = "Profile updated successfully")
                )
            }
            .onFailure { error ->
                throw BadRequestException(error.message ?: "Bad Request")
            }
    }


    suspend fun deleteUserProfile(call: ApplicationCall) {
        val id = call.parameters["id"]?.toIntOrNull()
            ?: throw BadRequestException("Invalid or missing id.")

        profileService.deleteUserProfile(id)
            .onSuccess { deleted ->
                if (deleted) {
                    call.respond(
                        HttpStatusCode.OK,
                        ApiResponse(success = true, data = true, message = "Profile deleted successfully")
                    )
                } else {
                    throw NotFoundException("Profile not found.")
                }
            }
            .onFailure { error ->
                throw InternalServerErrorException(message =  error.message ?: "Internal Server Error")
            }
    }
}