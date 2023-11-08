extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return DateTime(
      year,
      month,
      this.day + (day == weekday ? 7 : (day - weekday) % DateTime.daysPerWeek),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String capitalizeAllWords() {
    return split(' ').map((word) {
      if (word.isNotEmpty) {
        return word.capitalize();
      } else {
        return "";
      }
    }).join(' ');
  }
}
