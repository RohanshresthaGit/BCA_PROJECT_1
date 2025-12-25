package com.example.features.events.dto


import kotlinx.serialization.Serializable
import java.time.LocalDateTime

@Serializable
data class EventDto(
    val id: Int,
    val eventName: String,
    val description: String?,
    val organizedBy: String,
    val dateFrom: String,
    val dateTo: String,
    val timeFrom: String,
    val eventPhotoPath: String?,
    val timeTo: String,
    val address: String?,
    val latitude: Double?,
    val longitude: Double?,
    val createdAt: String,
    val updatedAt: String?
)

@Serializable
data class CreateEventRequest(
    val eventName: String,
    val description: String? = null,
    val organizedBy: String,
    val eventPhotoPath: String?,
    val dateFrom: String, // ISO format: 2024-12-25T00:00:00
    val dateTo: String ,
    val timeFrom: String, // Format: HH:mm
    val timeTo: String ,
    val address: String ,
    val latitude: Double? = null,
    val longitude: Double? = null
)

@Serializable
data class UpdateEventRequest(
    val eventName: String?,
    val description: String?,
    val dateFrom: String?,
    val dateTo: String?,
    val timeFrom: String?,
    val eventPhotoPath: String?,
    val timeTo: String?,
    val address: String?,
    val latitude: Double?,
    val longitude: Double?
)
