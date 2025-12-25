package com.example.core.exceptions

import io.ktor.http.*

open class AppException(
    message: String,
    val statusCode: HttpStatusCode
) : RuntimeException(message)

class NotFoundException(message: String) :
    AppException(message, HttpStatusCode.NotFound)

class UnauthorizedException(message: String) :
    AppException(message, HttpStatusCode.Unauthorized)

class ForbiddenException(message: String) :
    AppException(message, HttpStatusCode.Forbidden)

class BadRequestException(message: String) :
    AppException(message, HttpStatusCode.BadRequest)

class ConflictException(message: String) :
    AppException(message, HttpStatusCode.Conflict)

class InternalServerErrorException(message: String) :
    AppException(message, HttpStatusCode.InternalServerError)

