package com.example.features.profile.services

import UserProfile
import com.example.features.auth.models.User

interface ProfileService {
    suspend fun getUserProfile(userId: Int): Result<UserProfile>
    suspend fun getAllProfiles(): Result<List<UserProfile>>
    suspend fun updateUserProfile(userId: Int, request: UserProfile, photoBytes: ByteArray?, photoFileName: String?): Result<Unit>
    suspend fun deleteUserProfile(userId: Int): Result<Boolean>
}