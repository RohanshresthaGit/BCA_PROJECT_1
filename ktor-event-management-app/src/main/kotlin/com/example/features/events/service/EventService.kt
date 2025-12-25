package com.example.features.events.service


import com.example.core.cloudinary.CloudinaryConfig
import com.example.core.exceptions.ConflictException
import com.example.core.exceptions.NotFoundException
import com.example.features.auth.models.User
import com.example.features.auth.utils.UserRole
import com.example.features.events.dto.*
import com.example.features.events.repository.EventRepository
import io.ktor.http.content.*
import io.ktor.utils.io.*
import kotlinx.io.readByteArray
import java.io.File

class EventService(private val repository: EventRepository) {

    fun createEvent(request: CreateEventRequest): Result<String> {

        val event = repository.createEvent(request)
            ?: throw ConflictException("Failed to create event")
        return Result.success("Event Created Successfully with id: $event")
    }

    fun getEventById(id: Int): Result<EventDto> {
        val event = repository.getEventById(id)
            ?: return Result.failure(Exception("Event not found"))

        return Result.success(event)
    }

    fun getAllEvents(limit: Int = 100, offset: Long = 0): Result<List<EventDto>> {
        val events = repository.findAll(limit, offset)
        return Result.success(events)
    }

    suspend fun updateEvent(
        id: Int,
        request: UpdateEventRequest,
        photoBytes: ByteArray?,
        photoFileName: String?
    ): Result<String> {

        // Fetch existing event
        val existing = repository.getEventById(id)
            ?: return Result.failure(Exception("Event not found"))

        // Determine the final photo URL
        val photoUrl: String? = when {
            // New file provided and no URL sent → upload
            photoBytes != null -> {
                handleFileUploadToCloudinary(photoBytes, photoFileName, "events")
            }

            // Client sent existing URL → use it
            !request.eventPhotoPath.isNullOrBlank() -> request.eventPhotoPath

            // Otherwise, keep DB value
            else -> existing.eventPhotoPath
        }

        // Create final request with resolved photo URL
        val finalRequest = request.copy(eventPhotoPath = photoUrl)

        // Update event in DB (only changed fields)
        val msg = repository.updateEvent(id, finalRequest)
            ?: return Result.failure(Exception("Failed to update event"))

        return Result.success(msg)
    }



    fun deleteEvent(id: Int,): Result<Boolean> {
         repository.getEventById(id)
            ?:throw NotFoundException("Event Not Found.")


        val deleted = repository.deleteEvent(id)
        if (!deleted) {
            return Result.failure(Exception("Failed to delete event"))
        }

        return Result.success(true)
    }

    private suspend fun handleFileUploadToCloudinary( photoBytes: ByteArray, photoFileName: String?, folder: String): String? {


        val tempFile = java.io.File.createTempFile("upload-", photoFileName)
        tempFile.writeBytes(photoBytes)

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