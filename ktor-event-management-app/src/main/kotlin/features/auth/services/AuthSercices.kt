package com.example.features.auth.services

import com.example.features.auth.models.User
import com.example.features.auth.models.dto.LoginRequest
import com.example.features.auth.models.dto.SignUpRequestModel
import com.example.features.auth.models.dto.SignUpResponseModel

interface AuthService {
    suspend fun register(request: SignUpRequestModel): Result<User>
    suspend fun login(request: LoginRequest): Result<String>
}

