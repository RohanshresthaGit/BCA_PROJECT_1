package com.example.config

import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
//import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.v1.jdbc.Database

object DatabaseFactory {
    fun init(){
         val config = HikariConfig().apply{
            jdbcUrl = "jdbc:postgresql://localhost:5432/my_database"
            username = "Admin"
            password = "secret"
            driverClassName = "org.postgresql.Driver"
            isReadOnly = false
            maximumPoolSize = 10
            transactionIsolation = "TRANSACTION_SERIALIZABLE"
             connectionTimeout = 30_000
             idleTimeout = 600_000
             maxLifetime = 1_800_000
             leakDetectionThreshold = 2_000
        }
        Database.connect( HikariDataSource(config))
    }
}