package com.example.validators

import com.example.features.auth.models.dto.LoginRequest
import com.example.features.auth.models.dto.SignUpRequestModel
import io.ktor.server.plugins.*
import java.util.regex.Pattern

fun validateSignup(field: SignUpRequestModel): Result<String>
{
    val username = field.username
    val email = field.email
    val password = field.password
    val role = field.role

    // 🧍 Required fields
    if (username.isBlank() && password.isBlank() && email.isBlank())
        return Result.failure(Exception("Username, Password, and Email are required"))

    if (username.isBlank())
        return Result.failure(Exception("Username is required"))

    if (password.isBlank())
        return Result.failure(Exception("Password is required"))

    if (role.isBlank())
        return Result.failure(Exception("Role is required"))

    // 🧍 Username validation
    if (username.length < 3)
        return Result.failure(Exception("Username must be at least 3 characters long"))

    if (username.length > 20)
        return Result.failure(Exception("Username must not exceed 20 characters"))

    if (!username.matches(Regex("^[a-zA-Z0-9._-]+$")))
        return Result.failure(Exception("Username can only contain letters, numbers, dots, underscores, and hyphens"))

    // ✉️ Email Validation
    val emailRegex = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$")
    if (email.isBlank())
        return Result.failure(Exception("Email is required"))

    if (!emailRegex.matcher(email).matches())
        return Result.failure(Exception("Invalid email format"))

    // 🔐 Password Validation
    if (password.length < 8)
        return Result.failure(Exception("Password must be at least 8 characters long"))

    if (password.length > 32)
        return Result.failure(Exception("Password must not exceed 32 characters"))

    if (!password.any { it.isUpperCase() })
        return Result.failure(Exception("Password must contain at least one uppercase letter"))

    if (!password.any { it.isLowerCase() })
        return Result.failure(Exception("Password must contain at least one lowercase letter"))

    if (!password.any { it.isDigit() })
        return Result.failure(Exception("Password must contain at least one number"))

    if (!password.any { "!@#\$%^&*()-_=+[]{};:'\",.<>?/\\|`~".contains(it) })
        return Result.failure(Exception("Password must contain at least one special character (!@#\$%^&* etc.)"))

    // 🧩 Role Validation
    val allowedRoles = listOf("user", "admin", "organizer")
    if (role.lowercase() !in allowedRoles)
        return Result.failure(Exception("Role must be one of the following: ${allowedRoles.joinToString(", ")}"))

            // ✅ All validations passed
    return Result.success("Validation passed")
}


fun validateLogin(request: LoginRequest): Result<String> {
    val email = request.email.trim()
    val password = request.password.trim()

    // 🧍 Required fields
    if (email.isBlank() && password.isBlank())
        return Result.failure(Exception("Email and Password are required"))

    if (email.isBlank())
        return Result.failure(Exception("Email is required"))

    if (password.isBlank())
        return Result.failure(Exception("Password is required"))

    // ✉️ Email Validation
    val emailRegex = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$")
    if (!emailRegex.matcher(email).matches())
        return Result.failure(Exception("Invalid email format"))

    // 🔐 Password Validation
    if (password.length < 8)
        return Result.failure(Exception("Password must be at least 8 characters long"))

    // (Optional) You can relax these for login since signup already validated
    if (!password.any { it.isUpperCase() })
        return Result.failure(Exception("Password must contain at least one uppercase letter"))

    if (!password.any { it.isLowerCase() })
        return Result.failure(Exception("Password must contain at least one lowercase letter"))

    if (!password.any { it.isDigit() })
        return Result.failure(Exception("Password must contain at least one number"))

    if (!password.any { "!@#\$%^&*()-_=+[]{};:'\",.<>?/\\|`~".contains(it) })
        return Result.failure(Exception("Password must contain at least one special character (!@#\$%^&* etc.)"))

    // ✅ All validations passed
    return Result.success("Validation passed")
}
