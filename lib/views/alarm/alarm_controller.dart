import 'dart:async';
import 'package:get/get.dart';
import 'package:alarm/alarm.dart';
import 'package:alaram_app/utils/permissions.dart';
import 'package:alaram_app/models/alarm_model.dart';
import 'package:alaram_app/repository/alarm_repository.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AlarmController extends GetxController {
  bool isLoadingAlarms = false;

  bool isEditMode = false;

  static const String editUpdate = 'UPDATE_EDIT';

  List<AlarmModel> alarms = [];

  bool hasError = false;

  @override
  void onInit() {
    super.onInit();
    AlarmPermissions.checkNotificationPermission();
    if (Alarm.android) {
      AlarmPermissions.checkAndroidScheduleExactAlarmPermission();
    }

    getAllAlarms();
  }

  Future<void> getAllAlarms([
    bool silentUpdate = false,
  ]) async {
    if (!silentUpdate) isLoadingAlarms = true;
    update();
    alarms = await AlarmRepository.instance.getAllAlarms();
    alarms.sort((a, b) =>
        a.alarmSettings!.dateTime.isBefore(b.alarmSettings!.dateTime) ? 0 : 1);

    if (!silentUpdate) isLoadingAlarms = false;
    update();
  }

  void updateEdit() {
    isEditMode = !isEditMode;
    update();
  }

  Future<void> deleteAlarm(int id) async {
    await AlarmRepository.instance.deleteAlarm(id);
    alarms.removeWhere((e) => e.id == id);
    if (alarms.isEmpty) {
      isEditMode = false;
    }
    update();
  }
}
