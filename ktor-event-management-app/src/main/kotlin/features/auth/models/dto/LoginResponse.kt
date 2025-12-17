package com.example.features.auth.models.dto

import com.example.features.auth.models.User
import kotlinx.serialization.Serializable

@Serializable
data class LoginResponse(
    val success: Boolean,
    val message: String,
    val token: String? = null,
)

