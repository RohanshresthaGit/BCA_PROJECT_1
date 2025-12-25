package com.example.features.events.repository

import com.example.core.exceptions.NotFoundException
import com.example.features.events.db.Events
import com.example.features.events.dto.*
import org.jetbrains.exposed.v1.core.*
import org.jetbrains.exposed.v1.core.dao.id.EntityID
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import org.jetbrains.exposed.v1.jdbc.transactions.transaction
import org.jetbrains.exposed.v1.jdbc.*

class EventRepository {

    private val formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME

    fun createEvent(request: CreateEventRequest,): Int? = transaction {

        val now = LocalDateTime.now()
        val id = Events.insertAndGetId {
            it[eventName] = request.eventName
            it[description] = request.description
            it[organizedBy] = request.organizedBy
            it[eventPhotoPath] = request.eventPhotoPath
//            it[dateFrom] = LocalDateTime.parse(request.dateFrom, formatter)
            it[dateFrom] = request.dateFrom
//            it[dateTo] = request.dateTo?.let { dt -> LocalDateTime.parse(dt, formatter) }
            it[dateTo] = request.dateTo
            it[timeFrom] = request.timeFrom
            it[timeTo] = request.timeTo
            it[address] = request.address
            it[latitude] = request.latitude
            it[longitude] = request.longitude
            it[createdAt] = now.toString()
            it[updatedAt] = now.toString()
        }.value
        println("ID: $id")
     id
//        findById(id)
    }

//    fun findById(id: Int): EventDto? = transaction {
//        var a = Events.select(Events.id eq id).limit(1)
//        print(a)
//
//       Events
//            .select ( Events.id eq id )
//            .limit(1)
//            .map { rowToEventDto(it) }
//            .singleOrNull()
//    }

    fun findAll(limit: Int = 100, offset: Long = 0): List<EventDto> = transaction {
        Events.selectAll()
            .limit(limit)
            .offset(offset)
            .orderBy(Events.createdAt to SortOrder.DESC)
            .map { rowToEventDto(it) }
    }

    fun updateEvent(id: Int, request: UpdateEventRequest): String = transaction {
        val existing = getEventById(id)
            ?: throw NotFoundException("Event not found.")

        Events.update({ Events.id eq id }) {
            request.eventName?.let { name -> it[eventName] = name }
            request.description?.let { desc -> it[description] = desc }
            request.eventPhotoPath?.takeIf { it.isNotBlank() }?.let {photoPath -> it[eventPhotoPath] = photoPath}
            request.dateFrom?.let { df -> it[dateFrom] = df }
            request.dateTo?.let { dt -> it[dateTo] = dt }
            request.timeFrom?.let { tf -> it[timeFrom] = tf }
            request.timeTo?.let { tt -> it[timeTo] = tt }
            request.address?.let { addr -> it[address] = addr }
            request.latitude?.let { lat -> it[latitude] = lat }
            request.longitude?.let { lng -> it[longitude] = lng }
            it[updatedAt] = LocalDateTime.now().toString()
        }

        "Event Updated Successfully."
    }

    fun deleteEvent(id: Int): Boolean = transaction {
        Events.deleteWhere { Events.id eq id } > 0
    }

    fun getEventById(id: Int): EventDto? = transaction {

        Events
            .selectAll()
            .where { Events.id eq id}
            .limit(1)
            .map { row ->
                rowToEventDto(row)
            }
            .singleOrNull()
    }

    private fun rowToEventDto(row: ResultRow): EventDto {
        println(row)
        return EventDto(
            id = row[Events.id].value,
            eventName = row[Events.eventName],
            description = row[Events.description],
            organizedBy = row[Events.organizedBy],
            dateFrom = row[Events.dateFrom],
            dateTo = row[Events.dateTo],
            timeFrom = row[Events.timeFrom],
            timeTo = row[Events.timeTo],
            address = row[Events.address],
            latitude = row[Events.latitude],
            longitude = row[Events.longitude],
            createdAt = row[Events.createdAt],
            updatedAt = row[Events.updatedAt],
            eventPhotoPath = row[Events.eventPhotoPath]
        )
    }
}