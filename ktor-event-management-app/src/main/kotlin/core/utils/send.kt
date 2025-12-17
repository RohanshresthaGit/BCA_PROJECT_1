//package com.example.core.utils
//
//import io.ktor.http.*
//import io.ktor.server.application.*
//
//suspend fun ApplicationCall.send(response: Response) {
//    respond(
//        HttpStatusCode.fromValue(response.statusCode),
//        response
//    )
//}