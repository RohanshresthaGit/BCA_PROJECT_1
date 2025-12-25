package com.example.features.auth.services

import com.example.core.plugins.security.hashing.SHA256HashingService
import com.example.core.plugins.security.hashing.SaltedHash
import com.example.core.plugins.security.token.JwtTokenService
import com.example.core.plugins.security.token.TokenClaim
import com.example.core.plugins.security.token.TokenConfig
import com.example.features.auth.models.User
import com.example.features.auth.models.dto.LoginRequest
import com.example.features.auth.models.dto.SignUpRequestModel
import com.example.features.auth.repositories.UserRepository
import com.example.validators.validateLogin
import com.example.validators.validateSignup
import io.ktor.http.*

class AuthServiceImpl(
    private val userRepository: UserRepository,
    private val hashingService: SHA256HashingService,
    private val tokenConfig: TokenConfig
): AuthService {

    override suspend fun register(request: SignUpRequestModel): Result<User> {
        validateSignup(request).fold(
            onSuccess = { /* continue */ },
            onFailure = { return Result.failure(it) }
        )
        if (userRepository.findByEmail(request.email) != null)
            return Result.failure(Exception("User with this email already exists"))

        val saltedHash = hashingService.generateSaltedHash(request.password)

        val user = SignUpRequestModel(
            username = request.username,
            password = saltedHash.hash,
            email = request.email,
            role = request.role,
            salt = saltedHash.salt,
        )

        val userDetails = userRepository.createUser(user)  ?: return Result.failure(Exception("Failed to create user"))
        return Result.success(userDetails)

    }

    override suspend fun login(request: LoginRequest): Result< String> {

     validateLogin(request).fold(
         onSuccess = {},
         onFailure = { return Result.failure(it) }
     )

        val user = userRepository.findByEmail(request.email)
            ?: return Result.failure(Exception("User doesn't exists"))
print(user.password)
        // Step 3: Verify password
        val isPasswordValid = hashingService.verify(
            value = request.password,
            saltedHash = SaltedHash(
                hash = user.password,
                salt = user.salt
            )
        )
        if (!isPasswordValid) {
            return Result.failure(Exception("Invalid email or password"))
        }
        // Define your token configuration

        // Generate JWT token with user ID and email claims
        val tokenService = JwtTokenService()
        val token = tokenService.generate(
            config = tokenConfig,
            TokenClaim("userId", user.id.toString()),
            TokenClaim("email", user.email),
            TokenClaim("role", user.role)
        )

//        val token = tokenService.generate(tokenConfig)
        return Result.success(  token)
    }


}