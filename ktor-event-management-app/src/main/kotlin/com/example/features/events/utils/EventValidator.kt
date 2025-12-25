import com.example.features.events.dto.CreateEventRequest
import io.ktor.server.plugins.*
import kotlinx.datetime.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.time.format.DateTimeParseException

class EventValidator {

    companion object {

        fun validate(request: CreateEventRequest) {

            try {
                if (request.eventName.isBlank())
                    throw BadRequestException("Event name is required")

                if (request.organizedBy.isBlank()   )
                    throw BadRequestException("Organizer name is required")

                if (request.address.isBlank())
                    throw BadRequestException("Event address is required")
                val fromDate = LocalDate.parse(request.dateFrom)
                val toDate = LocalDate.parse(request.dateTo)
                if (fromDate.compareTo(toDate) > 0) {
                    throw BadRequestException("Event start date must be before end date")
                }
//                if (fromDate < toDate) {
//                    throw BadRequestException("Event start date must be before end date")
//                }
//                if (fromDate.isAfter(toDate))
//                    throw BadRequestException("Event start date must be before end date")

                // 3. Time validation (HH:mm)
                val timeFormatter = DateTimeFormatter.ofPattern("HH:mm")
                val fromTime = LocalTime.parse(request.timeFrom, timeFormatter)
                val toTime = LocalTime.parse(request.timeTo, timeFormatter)

//                // Same-day time validation (time can be equal)
//                if (fromDate.toLocalDate() == toDate.toLocalDate()) {
//                    if (fromTime.isAfter(toTime)) {
//                        throw BadRequestException(
//                            "Start time cannot be after end time for same-day events"
//                        )
//                    }
//                }

            } catch (e: DateTimeParseException) {
                throw BadRequestException("Invalid date or time format")
            }  catch (e: Exception) {
                // fallback safety
                throw BadRequestException("Failed to create event")
            }
        }
    }
}
