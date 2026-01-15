package com.example.features.BookEvents.DatabaseTable


import com.example.features.auth.databaseTable.Users
import com.example.features.events.db.Events
import org.jetbrains.exposed.v1.core.*
import org.jetbrains.exposed.v1.datetime.timestamp
import kotlin.time.ExperimentalTime

object EventBookings : Table("event_bookings") {

    val userId = integer("user_id")
        .references(Users.id, onDelete = ReferenceOption.CASCADE)

    val eventId = integer("event_id")
        .references(Events.id, onDelete = ReferenceOption.CASCADE)

    @OptIn(ExperimentalTime::class)
    val bookedAt = timestamp("booked_at")

    override val primaryKey = PrimaryKey(userId, eventId)
}
