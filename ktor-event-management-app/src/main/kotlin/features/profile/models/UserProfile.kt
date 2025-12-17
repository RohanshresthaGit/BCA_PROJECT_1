import kotlinx.serialization.Serializable

@Serializable
data class UserProfile (
    val id: Int? = null,
    val fullName: String? = null,
    val email: String? = null,
    val role: String? = null,
    val phone: String? = null,
    val gender: String? = null,
    val profilePicture: String? = null,
    val eventsAttended: Int? = null,
)