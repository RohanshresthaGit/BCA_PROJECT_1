package com.example.features.auth.utils

object AdminConfig {
    val USERNAME = System.getenv("ADMIN_USERNAME") ?: "admin"
    val PASSWORD = System.getenv("ADMIN_PASSWORD") ?: "@Admin333"
    val email = System.getenv("email") ?: "shrestharohan495@gmail.com"
    val ROLE = UserRole.ADMIN.name
}
