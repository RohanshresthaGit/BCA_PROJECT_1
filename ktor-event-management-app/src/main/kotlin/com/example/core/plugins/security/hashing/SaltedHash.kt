package com.example.core.plugins.security.hashing

data class SaltedHash(
    val hash: String,
    val salt: String,

)
