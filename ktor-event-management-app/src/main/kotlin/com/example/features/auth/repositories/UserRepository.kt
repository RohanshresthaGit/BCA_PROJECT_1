package com.example.features.auth.repositories

import com.example.core.plugins.security.hashing.HasingService
import com.example.features.auth.databaseTable.Users
import com.example.features.auth.models.User
import com.example.features.auth.models.dto.SignUpRequestModel
import com.example.features.auth.utils.AdminConfig
import com.example.features.auth.utils.UserRole
import org.jetbrains.exposed.v1.core.eq
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import org.jetbrains.exposed.v1.jdbc.transactions.transaction
import org.jetbrains.exposed.v1.jdbc.SchemaUtils
import org.jetbrains.exposed.v1.jdbc.insert
import org.jetbrains.exposed.v1.jdbc.select


class UserRepository {
    // Function to get current date/time as formatted string
     fun getCurrentDateTimeString(): String {
        val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd")
        return LocalDateTime.now().format(formatter)
    }

    fun findByEmail(email: String): User? = transaction {
        Users.select(listOf(Users.id, Users.fullName, Users.email, Users.role, Users.salt, Users.password))
            .map { row ->
                User(
                    id = row[Users.id],
                    username = row[Users.fullName],
                    password = row[Users.password],
                    email = row[Users.email],
                    role = row[Users.role],
                    salt = row[Users.salt]
                )
            }
            .firstOrNull {
                it.email == email }   // filter manually
    }

    fun createUser(request: SignUpRequestModel): User?{
        return try {
            transaction {
                val userId = Users.insert {
                    it[Users.fullName] = request.username
                    it[Users.password] = request.password
                    it[Users.email] = request.email
                    it[Users.salt] = request.salt
                    it[Users.role] = request.role
                    it[Users.createdAt] = getCurrentDateTimeString()
                } get Users.id

                // Return true if insert succeeded, false otherwise
                User(userId.toInt(), request.username, request.password, request.email, request.role)
            }
        } catch (e: Exception) {
            println("Error creating user: ${e.localizedMessage}")
            null
        }
    }

    fun ensureAdminExists(hashingService: HasingService) = transaction {
        SchemaUtils.create(Users)

        val adminExists = Users.select (
            Users.role eq UserRole.ADMIN.name ).count() > 1


        if (adminExists) return@transaction
        val saltedHash = hashingService.generateSaltedHash(AdminConfig.PASSWORD)
        Users.insert {
            it[fullName] = AdminConfig.USERNAME
            it[password] = saltedHash.hash
            it[email]= AdminConfig.email
            it[salt] = saltedHash.salt
            it[role] = AdminConfig.ROLE
            it[createdAt] = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))
        }
        println("Admin user created automatically.")
    }

}