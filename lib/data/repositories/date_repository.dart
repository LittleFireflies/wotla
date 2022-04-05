class DateRepository {
  DateTime get today {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }
}
