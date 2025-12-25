package com.example.features.auth.databaseTable

import org.jetbrains.exposed.v1.core.Table


object Users: Table("users"){
        val id = integer("id").autoIncrement().uniqueIndex()
        val fullName = varchar("fullName", length = 70)
        val password = varchar("password", length = 100)
        val email = varchar("email", length = 70).uniqueIndex()
        val role = varchar("role", length = 10)
        val salt = varchar("salt", length = 100)
        val createdAt = varchar("createdAt", length = 10)

        val profilePicture = varchar("profilePicture", length = 200).nullable()
        val phone = varchar("phone", length = 10).nullable()
        val gender = varchar("gender", 6).nullable()
        val eventsAttended = integer("eventsAttended").nullable()
        val updatedAt = varchar("updatedAt", length = 20).nullable()

        override val primaryKey = PrimaryKey(id)

}