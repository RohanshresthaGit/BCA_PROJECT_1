package com.example.features.auth.middleware
import com.example.features.auth.utils.UserRole
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*

suspend fun authorize(
    call: ApplicationCall,
    allowedRoles: List<UserRole>,
    targetUserId: Int? = null
): Boolean {

    val principal = call.principal<JWTPrincipal>() ?: return false

    // Get role from token and convert to enum
    val roleString = principal.payload.getClaim("role").asString() ?: return false
    println("Role string: $roleString")
    val role = try {

        UserRole.valueOf(roleString)
    } catch (e: IllegalArgumentException) {
        return false
    }

    val userIdFromToken = principal.payload.getClaim("userId").asString().toInt()

    // Check if the role is allowed
    if (!allowedRoles.contains(role)) return false

    // If ownership check is required
    if (targetUserId != null && role != UserRole.ADMIN) {
        if (userIdFromToken != targetUserId) return false
    }

    return true
}
