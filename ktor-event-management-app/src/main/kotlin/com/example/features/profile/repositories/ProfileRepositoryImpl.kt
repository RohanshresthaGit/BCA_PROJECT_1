package com.example.features.profile.repositories

import UserProfile
import com.example.core.exceptions.NotFoundException
import com.example.features.auth.databaseTable.Users
import org.jetbrains.exposed.v1.core.ResultRow
import org.jetbrains.exposed.v1.core.eq
import org.jetbrains.exposed.v1.jdbc.deleteWhere
import org.jetbrains.exposed.v1.jdbc.select
import org.jetbrains.exposed.v1.jdbc.selectAll
import org.jetbrains.exposed.v1.jdbc.transactions.experimental.newSuspendedTransaction
import org.jetbrains.exposed.v1.jdbc.update

class ProfileRepositoryImpl(): ProfileRepository {

    private suspend fun <T> dbQuery(block: suspend () -> T): T =
        newSuspendedTransaction { block() }

    private fun ResultRow.toProfile() = UserProfile(
        id = this[Users.id],
        fullName = this[Users.fullName],
        email = this[Users.email],
        role = this[Users.role],
        phone = this[Users.phone],
        gender = this[Users.gender],
        profilePicture = this[Users.profilePicture],
        eventsAttended = this[Users.eventsAttended]
    )

    override suspend fun findByUserId(userId: Int): Result<UserProfile> = runCatching {
        dbQuery {

            Users.select(listOf(Users.id, Users.fullName, Users.email, Users.role, Users.phone, Users.gender, Users.eventsAttended, Users.profilePicture))
                .where(Users.id eq userId)
                .map { row ->
                    UserProfile(
                        id = row[Users.id],
                        fullName = row[Users.fullName],
                        email = row[Users.email],
                        role = row[Users.role],
                        phone = row[Users.phone],
                        gender = row[Users.gender],
                        eventsAttended = row[Users.eventsAttended],
                        profilePicture = row[Users.profilePicture]
                    )
                }
                .singleOrNull()
                ?: throw NotFoundException(message = "Profile not found for user with user id $userId")//error("Profile not found for user")
        }
    }

    override suspend fun findAll(): Result<List<UserProfile>> = runCatching {
        dbQuery {
            Users.selectAll()
                .map { it.toProfile() }
        }
    }

    override suspend fun update(id: Int, request: UserProfile, profilePicturePath :String? ): Result<Unit> = runCatching {
        dbQuery {
            val exists = Users.select(Users.id eq id).count() > 0
            if (!exists) throw NotFoundException("Profile not found for user with userId $id")

           Users.update({ Users.id eq id }) {
                request.fullName?.let { value -> it[fullName] = value }
                profilePicturePath?.let { value -> it[profilePicture] = value }
                request.email?.let { value -> it[email] = value }
                request.gender?.let { value -> it[gender] = value }
                request.eventsAttended?.let { value -> it[eventsAttended] = value }
                request.phone?.let { value -> it[phone] = value }
            }
            Unit
        }
    }

    override suspend fun delete(id: Int): Boolean {
        return dbQuery {
            Users.deleteWhere { Users.id eq id } > 0
        }
    }
}

