package com.example.features.auth.models

import kotlinx.serialization.Serializable

@Serializable
data class User(
    val id: Int,
    val username: String,
    val password: String = "",
    val email: String,
    val role: String,
    val salt: String = "",
//    val createdAt: String
)
