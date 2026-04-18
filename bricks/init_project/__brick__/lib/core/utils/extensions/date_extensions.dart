import 'package:flutter/material.dart';

const monthsInYear = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec'
};

const monthsInYearFull = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December'
};

const weekdayMap = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday"
};

extension DateFeatures on DateTime {
  String? get dayname => weekdayMap[weekday];
  String? get dayNameShort => weekdayMap[weekday]!.substring(0, 3);

  ({int days, int hours, int minutes, int seconds}) formattedDuration() {
    final duration = difference(DateTime.now());
    final days = duration.inDays.abs();
    final hours = duration.inHours.remainder(24).abs();
    final minutes = duration.inMinutes.remainder(60).abs();
    final seconds = duration.inSeconds.remainder(60).abs();
    return (seconds: seconds, minutes: minutes, hours: hours, days: days);
  }

  int get weekOfMonth {
    var date = this;
    final firstDayOfTheMonth = DateTime(date.year, date.month, 1);
    int sum = firstDayOfTheMonth.weekday - 1 + date.day;
    if (sum % 7 == 0) {
      return sum ~/ 7;
    } else {
      return sum ~/ 7 + 1;
    }
  }

  String get formattedMonth {
    try {
      return monthsInYear[month].toString();
    } catch (e) {
      rethrow;
    }
  }

  String get formattedMonthFull {
    try {
      return monthsInYearFull[month].toString();
    } catch (e) {
      rethrow;
    }
  }

  String get formattedTimeIn12Hr {
    try {
      // final hr = hour<10?'0$hour':'$hour';
      final min = minute < 10 ? '0$minute' : '$minute';
      final period = TimeOfDay.fromDateTime(this).period.name;
      final hr = period.toUpperCase() == 'PM' && hour > 12 ? hour - 12 : hour;
      return '$hr:$min ${period.toUpperCase()}';
    } catch (e) {
      rethrow;
    }
  }

  String get formattedDay {
    try {
      final dayString = day.toString();
      final lastCharacter = dayString[dayString.length - 1];
      final suffix = (day > 3 && day < 21)
          ? 'th'
          : (lastCharacter == '1'
              ? 'st'
              : lastCharacter == '2'
                  ? 'nd'
                  : lastCharacter == '3'
                      ? 'rd'
                      : 'th');
      return day.toString() + suffix;
    } catch (e) {
      rethrow;
    }
  }

  String get fieldFormattedDate {
    final finalDay = day < 10 ? '0$day' : day;
    final finalMonth = month < 10 ? '0$month' : month;

    return '$year | $finalMonth | $finalDay';
  }

  /// compares year, month and day.
  /// If these values are equals, returns true otherwise false
  bool isAtSameDateAs(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  ///treats the date as utc and converts to local
  DateTime get asUtcToLocal {
    return DateTime.utc(
            year, month, day, hour, minute, second, millisecond, microsecond)
        .toLocal();
  }
}
