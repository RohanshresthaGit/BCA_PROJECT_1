extension DateTimeFormatter on String {
  /// Converts a date string "yyyy-MM-dd" to "MMM d" (e.g., "2025-01-01" -> "Jan 1")
  String toMonthDay() {
    try {
      final date = DateTime.parse(this);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}';
    } catch (e) {
      return this; // return original if parsing fails
    }
  }

  /// Converts a time string "HH:mm" to "h AM/PM" (e.g., "18:00" -> "6 PM")
  String to12HourTime() {
    try {
      final parts = this.split(':');
      if (parts.length != 2) return this;

      int hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;

      // If minutes are 0, just show hour; else include minutes
      return minute == 0 ? '$hour $period' : '$hour:$minute $period';
    } catch (e) {
      return this; // return original if parsing fails
    }
  }

    /// Capitalizes the first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
