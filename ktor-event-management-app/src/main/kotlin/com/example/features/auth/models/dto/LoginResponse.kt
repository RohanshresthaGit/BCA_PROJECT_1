package com.example.features.auth.models.dto

import com.example.features.auth.models.User
import com.example.features.auth.services.AuthResponse
import kotlinx.serialization.Serializable

@Serializable
data class LoginResponse(
    val success: Boolean,
    val message: String,
    val user: AuthResponse? = null,
)

