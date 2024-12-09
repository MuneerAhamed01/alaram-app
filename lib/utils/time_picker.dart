import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void showCupertinoTimePicker(
  DateTime selectedTime,
  Function(TimeOfDay time) onChange,
) {
  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    builder: (_) {
      return SizedBox(
        height: Get.height * 0.2,
        child: CupertinoTimerPicker(
          mode: CupertinoTimerPickerMode.hm,
          initialTimerDuration: Duration(
            hours: selectedTime.hour,
            minutes: selectedTime.minute,
          ),
          onTimerDurationChanged: (Duration newDuration) {
            final newTime = TimeOfDay(
              hour: newDuration.inHours,
              minute: newDuration.inMinutes % 60,
            );
            // controller.updateTime(newTime);
            onChange(newTime);
          },
        ),
      );
    },
  );
}
