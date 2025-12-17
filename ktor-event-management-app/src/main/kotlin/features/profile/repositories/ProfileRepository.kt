package com.example.features.profile.repositories

import UserProfile

interface ProfileRepository {
    suspend fun findByUserId(userId: Int): Result<UserProfile>
    suspend fun findAll(): Result<List<UserProfile>>
    suspend fun update(id: Int, request: UserProfile, profilePicturePath: String?): Result<Unit>
    suspend fun delete(id: Int): Boolean
}