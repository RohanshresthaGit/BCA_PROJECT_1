package com.example.core.plugins.security.token

import com.auth0.jwt.JWT
import com.auth0.jwt.JWTVerifier
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.JWTVerificationException
import com.auth0.jwt.interfaces.DecodedJWT
import java.util.*

class JwtTokenService: TokenService {
    override fun generate(config: TokenConfig, vararg claims: TokenClaim): String {
        var token = JWT.create()
            .withAudience(config.audience)
            .withIssuer(config.issuer)
            .withExpiresAt(Date(System.currentTimeMillis() + config.expiresIn))

        claims.forEach { claim ->
            token = token.withClaim(claim.name, claim.value)
        }
        return token.sign(Algorithm.HMAC256(config.secret))
    }

    fun verify(token: String, config: TokenConfig): DecodedJWT? {
        return try {
            val algorithm = Algorithm.HMAC256(config.secret)
            val verifier: JWTVerifier = JWT.require(algorithm)
                .withAudience(config.audience)
                .withIssuer(config.issuer)
                .build()

            verifier.verify(token) // returns DecodedJWT if valid
        } catch (e: JWTVerificationException) {
            null
        }
    }
}