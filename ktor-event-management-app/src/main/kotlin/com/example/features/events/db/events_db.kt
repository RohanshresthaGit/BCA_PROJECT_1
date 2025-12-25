package com.example.features.events.db


import com.example.features.auth.databaseTable.Users
import com.example.features.auth.databaseTable.Users.nullable
import com.example.features.auth.databaseTable.Users.uniqueIndex
import org.jetbrains.exposed.v1.core.Table
import org.jetbrains.exposed.v1.core.dao.id.IntIdTable

object Events : IntIdTable("events") {
//    val id = integer("id").autoIncrement().uniqueIndex()
    val eventName = varchar("eventName", 255)
    val eventPhotoPath = varchar("eventPhotoPath", length = 300).nullable()
    val description = text("description").nullable()
    val organizedBy = varchar("organizedBy", 100)
    val dateFrom = varchar("dateFrom", 10)
    val dateTo = varchar("dateTo", 10)
    val timeFrom = varchar("timeFrom", 10)
    val timeTo = varchar("timeTo", 10)
    val address = text("address").nullable()
    val latitude = double("latitude").nullable()
    val longitude = double("longitude").nullable()
    val createdAt = varchar("createdAt", 30)
    val updatedAt = varchar("updatedAt",30).nullable()

//    override val primaryKey = PrimaryKey(id)
}