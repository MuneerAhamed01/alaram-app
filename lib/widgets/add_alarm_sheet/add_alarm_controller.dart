import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alaram_app/models/alarm_model.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alaram_app/repostiory/alarm_repository.dart';

class AddAlarmController extends GetxController {
  RxBool isLoading = false.obs;

  AlarmModel? alarm;

  bool get isEditing => alarm != null;

  bool repeat = false;

  late FixedExtentScrollController hourExtend;

  late FixedExtentScrollController minuteExtend;

  late FixedExtentScrollController amOrPmExtend;

  final TextEditingController labelController = TextEditingController();

  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  bool snooze = false;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() {
    if (!isEditing) {
      hourExtend = FixedExtentScrollController(
        initialItem: max(selectedTime.value.hour - 1, 0),
      );

      minuteExtend = FixedExtentScrollController(
        initialItem: selectedTime.value.minute,
      );

      amOrPmExtend = FixedExtentScrollController(
        initialItem: selectedTime.value.period == DayPeriod.am ? 0 : 1,
      );
    } else {
      final hourIn12 = (alarm!.alarmSettings!.dateTime.hour % 12 == 0)
          ? 12
          : alarm!.alarmSettings!.dateTime.hour % 12;
      hourExtend = FixedExtentScrollController(
        initialItem: hourIn12,
      );
      minuteExtend = FixedExtentScrollController(
        initialItem: alarm?.alarmSettings!.dateTime.minute ?? 0,
      );

      amOrPmExtend = FixedExtentScrollController(
        initialItem: alarm!.alarmSettings!.dateTime.hour < 12 ? 0 : 1,
      );
    }
  }

  void updateTime(TimeOfDay newTime) {
    selectedTime.value = newTime;
  }

  // final AlarmService
  Future<void> saveAlarm() async {
    isLoading.value = true;
    final alarmSettings = _buildAlarmSettings();
    final AlarmModel model = AlarmModel(
      id: alarmSettings.id,
      label: labelController.text.isNotEmpty ? labelController.text : "Alarm",
      isEnabled: true,
      isDeleted: false,
      alarmSettings: alarmSettings,
    );

    await AlarmRepository.instance.addAlarm(model);

    isLoading.value = false;
  }

  AlarmSettings _buildAlarmSettings() {
    final id = !isEditing
        ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
        : alarm!.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: DateTime.now().copyWith(
        hour: hourExtend.selectedItem + 1,
        minute: minuteExtend.selectedItem,
      ),
      vibrate: false,
      assetAudioPath: 'assets/ringtone/marimba.mp3',
      warningNotificationOnKill: Platform.isIOS,
      notificationSettings: NotificationSettings(
        title: "It's Time",
        body: labelController.text.isNotEmpty
            ? labelController.text
            : "Alarm is ringing",
        stopButton: 'Stop',
        icon: 'notification_icon',
      ),
    );
    return alarmSettings;
  }
}
