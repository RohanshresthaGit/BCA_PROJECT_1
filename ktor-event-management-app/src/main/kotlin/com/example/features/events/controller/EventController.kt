package com.example.features.events.controller

import EventValidator
import com.example.core.cloudinary.CloudinaryConfig
import com.example.core.exceptions.BadRequestException
import com.example.core.exceptions.ConflictException
import com.example.core.exceptions.ForbiddenException
import com.example.core.exceptions.NotFoundException
import com.example.core.utils.ApiResponse
import com.example.features.events.dto.*
import com.example.features.events.service.*
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.utils.io.*
import kotlinx.io.readByteArray

class EventController(private val service: EventService) {

    suspend fun createEvent(call: ApplicationCall) {
        var eventName = ""
        var description: String? = null
        var organizedBy = ""
        var dateFrom = ""
        var dateTo = ""
        var timeFrom = ""
        var timeTo = ""
        var address = ""
        var latitude: Double? = null
        var longitude: Double? = null
        var eventPhotoUrl: String? = null

        val multipart = call.receiveMultipart()
        multipart.forEachPart { part ->
            when (part) {
                is PartData.FormItem -> {
                    when (part.name) {
                        "eventName" -> eventName = part.value
                        "description" -> description = part.value
                        "organizedBy" -> organizedBy = part.value
                        "dateFrom" -> dateFrom = part.value
                        "dateTo" -> dateTo = part.value
                        "timeFrom" -> timeFrom = part.value
                        "timeTo" -> timeTo = part.value
                        "address" -> address = part.value
                        "eventPhotoUrl" -> eventPhotoUrl = part.value
                        "latitude" -> latitude = part.value.toDoubleOrNull()
                        "longitude" -> longitude = part.value.toDoubleOrNull()
                    }
                }
                is PartData.FileItem -> {
                    if (part.name == "eventPhotoPath") {
                        eventPhotoUrl = handleFileUploadToCloudinary(part, "events")
                    }
                }
                else -> {}
            }
            part.dispose()
        }

        val request = CreateEventRequest(
            eventName = eventName,
            description = description,
            organizedBy = organizedBy,
            eventPhotoPath = eventPhotoUrl ?: "",
            dateFrom = dateFrom,
            dateTo = dateTo,
            timeFrom = timeFrom,
            timeTo = timeTo,
            address = address,
            latitude = latitude,
            longitude = longitude
        )
        EventValidator.validate(request)
        service.createEvent(request).fold(
            onSuccess = { message ->
                call.respond(HttpStatusCode.Created, ApiResponse(success = true, data = message))
            },
            onFailure = { error ->
                throw ConflictException(error.message ?: "Failed to create an event.")
            }
        )
    }

//    suspend fun createEvent(call: ApplicationCall) {
//        val request = call.receive<CreateEventRequest>()
//        EventValidator.validate(request)
//        service.createEvent(request).fold(
//            onSuccess = { event ->
//                call.respond(
//                    HttpStatusCode.Created,
//                    ApiResponse(success = true, data = event)
//                )
//
//            },
//            onFailure = { error ->
//                throw ConflictException(message = error.message ?: "Failed to create an event.")
//            }
//        )
//    }

    suspend fun getEvent(call: ApplicationCall) {
        val id = call.parameters["id"]?.toIntOrNull() ?: throw BadRequestException("Invalid or missing event id.")
        service.getEventById(id).fold(
            onSuccess = { event ->
                call.respond(
                    HttpStatusCode.OK,event
                )
            },
            onFailure = { error ->
                throw NotFoundException(error.message ?: "Event Not found!")
            }
        )
    }

    suspend fun getAllEvents(call: ApplicationCall) {
        val limit = call.request.queryParameters["limit"]?.toIntOrNull() ?: 100
        val offset = call.request.queryParameters["offset"]?.toLongOrNull() ?: 0

        service.getAllEvents(limit, offset).fold(
            onSuccess = { events ->
                call.respond(
                    HttpStatusCode.OK,
                     events
                )
            },
            onFailure = { error ->
               throw NotFoundException(error.message ?: "Events Not Found!")
            }
        )
    }

    suspend fun updateEvent(call: ApplicationCall) {

        val id = call.parameters["id"]?.toIntOrNull()
            ?: throw BadRequestException("Invalid event id")

        var eventName: String? = null
        var description: String? = null
        var dateFrom: String? = null
        var dateTo: String? = null
        var timeFrom: String? = null
        var timeTo: String? = null
        var address: String? = null
        var latitude: Double? = null
        var longitude: Double? = null
        var eventPhotoPath: String? = null

        var photoBytes: ByteArray? = null
        var photoFileName: String? = null

        val multipart = call.receiveMultipart()
        multipart.forEachPart { part ->
            when (part) {

                is PartData.FormItem -> {
                    when (part.name) {
                        "eventName" -> eventName = part.value
                        "description" -> description = part.value
                        "dateFrom" -> dateFrom = part.value
                        "dateTo" -> dateTo = part.value
                        "timeFrom" -> timeFrom = part.value
                        "timeTo" -> timeTo = part.value
                        "address" -> address = part.value
                        "eventPhotoPath" -> eventPhotoPath = part.value
                        "latitude" -> latitude = part.value.toDoubleOrNull()
                        "longitude" -> longitude = part.value.toDoubleOrNull()
                    }
                }

                is PartData.FileItem -> {
                    if (part.name == "eventPhoto") {
                        photoFileName = part.originalFileName
                        photoBytes = part.streamProvider().readBytes()
                    }
                }

                else -> Unit
            }
            part.dispose()
        }

        val request = UpdateEventRequest(
            eventName = eventName,
            description = description,
            dateFrom = dateFrom,
            dateTo = dateTo,
            timeFrom = timeFrom,
            timeTo = timeTo,
            address = address,
            latitude = latitude,
            longitude = longitude,
            eventPhotoPath = eventPhotoPath,

        )

        service.updateEvent(id, request, photoBytes, photoFileName)
            .fold(
                onSuccess = { call.respond(HttpStatusCode.OK, ApiResponse(true,it)) },
                onFailure = { throw ConflictException(it.message ?: "Failed to update event") }
            )
    }


    suspend fun deleteEvent(call: ApplicationCall) {
        val id = call.parameters["id"]?.toIntOrNull() ?: throw BadRequestException("Invalid or missing event id.")

        service.deleteEvent(id).fold(
            onSuccess = {
                call.respond(HttpStatusCode.OK, ApiResponse(success = true, data = "Event deleted successfully"))
            },
            onFailure = { error ->
                throw ForbiddenException(error.message ?: "Failed to delete event")
            }
        )
    }

    private suspend fun handleFileUploadToCloudinary(filePart: PartData.FileItem, folder: String): String? {
        val fileBytes = filePart.provider().readRemaining().readByteArray()
        val fileName = filePart.originalFileName ?: "file_${System.currentTimeMillis()}.jpg"

        val tempFile = java.io.File.createTempFile("upload-", fileName)
        tempFile.writeBytes(fileBytes)

        val uploadResult = CloudinaryConfig.cloudinary.uploader().upload(
            tempFile, mapOf(
                "folder" to folder,
                "public_id" to "event_${System.currentTimeMillis()}",
                "overwrite" to true
            )
        )

        tempFile.delete()
        return uploadResult["secure_url"] as? String
    }
}