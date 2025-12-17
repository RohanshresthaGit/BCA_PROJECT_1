package com.example.features.profile.services

import UserProfile
import com.example.core.cloudinary.CloudinaryConfig
import com.example.core.exceptions.BadRequestException
import com.example.core.utils.validator.Validator
import com.example.features.profile.repositories.ProfileRepository
import java.lang.Exception

class ProfileServiceImpl(
    private val repository: ProfileRepository
): ProfileService{
    override suspend fun getUserProfile(userId: Int): Result<UserProfile> {
        return repository.findByUserId(userId)
    }

    override suspend fun getAllProfiles(): Result<List<UserProfile>> {
        return repository.findAll()
    }

   override suspend fun updateUserProfile(
        userId: Int,
        request: UserProfile,
        photoBytes: ByteArray?,
        photoFileName: String?
    ): Result<Unit> {

        // Validate email if provided
        request.email?.let {
            if (!Validator.isValidEmail(it)) {
                throw BadRequestException("Incorrect email format.")
            }
        }

        // Upload photo to Cloudinary if provided
        val profilePictureUrl: String? = photoBytes?.let { bytes ->
            val tempFile = java.io.File.createTempFile("upload-", photoFileName ?: "temp.jpg")
            tempFile.writeBytes(bytes)

            val uploadResult = CloudinaryConfig.cloudinary.uploader().upload(
                tempFile, mapOf(
                    "folder" to "user_profiles",
                    "public_id" to "user_$userId",
                    "overwrite" to true
                )
            )

            tempFile.delete()

            uploadResult["secure_url"] as? String
        }

        repository.update(userId, request, profilePictureUrl)
        return Result.success(Unit)
    }


    override suspend fun deleteUserProfile(userId: Int): Result<Boolean> =
        if (repository.delete(userId)) {
            Result.success(true)
        } else {
            Result.failure(Exception("Failed to delete user"))
        }
}


