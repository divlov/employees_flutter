extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return DateTime(
      year,
      month,
      this.day + (day == weekday ? 7 : (day - weekday) % DateTime.daysPerWeek),
    );
  }
}