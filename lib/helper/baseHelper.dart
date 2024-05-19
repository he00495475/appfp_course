import 'package:flutter/material.dart';

class BaseHelper {
  static List<String> daysOfWeek = ['一', '二', '三', '四', '五', '六', '日'];

  // 將字串轉換為 TimeOfDay
  static TimeOfDay convertStringToTimeOfDay(String timeString) {
    if (timeString.isEmpty) {
      return TimeOfDay.now();
    }
    List<String> timeParts = timeString.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static List<int> getDaysOfWeekIndexs(List<String> courseWeek) {
    List<int> selectedDays = [];
    for (final day in courseWeek) {
      if (daysOfWeek.contains(day)) {
        selectedDays.add(daysOfWeek.indexOf(day));
      }
    }

    return selectedDays;
  }
}
