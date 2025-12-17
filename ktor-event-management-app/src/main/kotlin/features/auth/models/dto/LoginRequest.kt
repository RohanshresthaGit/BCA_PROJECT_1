package com.example.features.auth.models.dto

import kotlinx.serialization.Serializable

@Serializable
data class LoginRequest(
    val email: String,
    val password: String,
    val role: String = "USER"
)
