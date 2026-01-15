package com.example.features.BookEvents.service


import com.example.core.exceptions.ConflictException
import com.example.features.BookEvents.DatabaseTable.EventBookings
import com.example.features.auth.databaseTable.Users
import com.example.features.events.db.Events
import org.jetbrains.exposed.v1.core.and
import org.jetbrains.exposed.v1.core.eq
import org.jetbrains.exposed.v1.core.intLiteral
import org.jetbrains.exposed.v1.core.plus
import org.jetbrains.exposed.v1.jdbc.insert
import org.jetbrains.exposed.v1.jdbc.select
import org.jetbrains.exposed.v1.jdbc.selectAll
import org.jetbrains.exposed.v1.jdbc.transactions.transaction
import org.jetbrains.exposed.v1.jdbc.update
import java.time.LocalDateTime
import kotlin.time.Clock
import kotlin.time.ExperimentalTime

object BookingService {

    @OptIn(ExperimentalTime::class)
    fun bookEvent(userId: Int, eventId: Int) {
        transaction {

           Users
                .selectAll().where { Users.id eq userId }
                .singleOrNull() ?: error("User not found")

            // 2️⃣ Validate Event
            Events
                .selectAll().where ( Events.id eq eventId )
                .singleOrNull() ?: error("Event not found")

            // 3️⃣ Prevent duplicate booking
            val alreadyBooked = EventBookings
                .selectAll().where (
                    (EventBookings.userId eq userId) and
                            (EventBookings.eventId eq eventId)
                )
                .empty().not()

            if (alreadyBooked) {
                throw ConflictException("Event already booked")
            }

            // 4️⃣ Insert booking
            EventBookings.insert {
                it[EventBookings.userId] = userId
                it[EventBookings.eventId] = eventId
                it[bookedAt] = Clock.System.now()
            }

            Users.update({ Users.id eq userId }) {
                it.update(
                    eventsAttended,
                    eventsAttended + 1
                )
            }
        }
    }

    fun checkIsEventBooked(userId: Int, eventId: Int) {
        transaction {
            Users
                .selectAll().where { Users.id eq userId }
                .singleOrNull() ?: error("User not found")

            // 2️⃣ Validate Event
            Events
                .selectAll().where(Events.id eq eventId)
                .singleOrNull() ?: error("Event not found")

            // 3️⃣ Prevent duplicate booking
            val alreadyBooked = EventBookings
                .selectAll().where(
                    (EventBookings.userId eq userId) and
                            (EventBookings.eventId eq eventId)
                )
                .empty().not()

            if (!alreadyBooked) {
                throw ConflictException("Event not booked yet.")
            }
        }
    }
}
