package com.example.core.plugins

import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.plugins.contentnegotiation.*
import kotlinx.serialization.json.Json


fun Application.configureSerialization() {
    install(ContentNegotiation) {
        json(
            Json {
                explicitNulls = false    // omit null values
                prettyPrint = true
                encodeDefaults = true  // optional, formats JSON nicely
            }
        ) // kotlinx.serialization
    }
}
