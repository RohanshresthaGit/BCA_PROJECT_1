package com.example.features.auth.models.dto

import kotlinx.serialization.Serializable


@Serializable
data class SignUpRequestModel(
    val username: String = "",
    val password: String = "",
    val email: String = "",
    val salt: String = "",
    val role: String,
)
