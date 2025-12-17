plugins {
    alias(libs.plugins.kotlin.jvm)
    alias(libs.plugins.ktor)
    alias(libs.plugins.kotlin.plugin.serialization)
}
group = "com.example"
version = "0.0.1"
application {
    mainClass = "io.ktor.server.netty.EngineMain"

    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=true")
}
dependencies {
    implementation(libs.ktor.server.core)
    implementation(libs.ktor.serialization.kotlinx.json)
    implementation(libs.ktor.server.content.negotiation)
    implementation(libs.postgresql)
    implementation(libs.ktor.server.auth)
    implementation(libs.ktor.server.auth.jwt)
    implementation(libs.ktor.server.netty)
    implementation(libs.logback.classic)
    implementation(libs.ktor.server.config.yaml)
    testImplementation(libs.ktor.server.test.host)
    testImplementation(libs.kotlin.test.junit)
    implementation(libs.exposed.core)
    implementation(libs.exposed.dao)
    implementation(libs.exposed.jdbc)
    implementation(libs.exposed.kotlin.datetime)
    implementation(libs.hikaricp)
    implementation(libs.ktor.server.status.pages)

    implementation("io.github.cdimascio:dotenv-kotlin:6.4.1")
    implementation("commons-codec:commons-codec:1.16.0")
    implementation("com.cloudinary:cloudinary-http44:1.36.0")

} // Exposed Kotlin datetime support implementation("org.jetbrains.exposed:exposed-kotlin-datetime:0.55.0") // PostgresQL driver implementation("org.postgresql:postgresql:42.7.3") // For environment config implementation("io.github.cdimascio:dotenv-kotlin:6.4.1") implementation("io.ktor:ktor-server-status-pages:3.0.0") implementation("commons-codec:commons-codec:1.16.0") }