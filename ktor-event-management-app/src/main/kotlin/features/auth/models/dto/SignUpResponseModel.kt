package com.example.features.auth.models.dto

import kotlinx.serialization.Serializable
import com.example.features.auth.models.User

@Serializable
data class SignUpResponseModel(
    val success: Boolean ,
    val message: String,
//    val user: User? = null
)


