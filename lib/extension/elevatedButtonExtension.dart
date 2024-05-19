import 'package:flutter/material.dart';

extension ElevatedButtonExtension on ElevatedButton {
  ElevatedButton withTimePicker(
      BuildContext context, TimeOfDay? startTime, TimeOfDay? endTime,
      {required Function(TimeOfDay, TimeOfDay) onTimeSelected}) {
    return ElevatedButton(
      onPressed: () async {
        TimeOfDay? pickedStartTime = await showTimePicker(
          context: context,
          initialTime: startTime ?? TimeOfDay.now(),
        );

        if (pickedStartTime == null) return;
        TimeOfDay? pickedEndTime = await showTimePicker(
          context: context,
          initialTime: endTime ??
              pickedStartTime.replacing(
                  minute: (pickedStartTime.minute + 30) % 60),
        );

        if (pickedEndTime == null) return;

        // 調整時間，如果開始時間大於結束時間，則設置開始時間小於結束時間 30 分鐘
        int pickedStartMinutes =
            pickedStartTime.hour * 60 + pickedStartTime.minute;
        int pickedEndMinutes = pickedEndTime.hour * 60 + pickedEndTime.minute;

        if (pickedStartMinutes > pickedEndMinutes) {
          pickedStartTime = pickedEndTime.replacing(
            hour: (pickedEndTime.hour - 1 + 24) % 24,
            minute: (pickedEndTime.minute + 30) % 60,
          );
        }

        onTimeSelected(pickedStartTime, pickedEndTime);
      },
      child: child,
    );
  }
}
