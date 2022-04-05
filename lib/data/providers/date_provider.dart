class DateProvider {
  DateTime get today {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  DateTime get tomorrow{
    return today.add(const Duration(days: 1));
  }
}
