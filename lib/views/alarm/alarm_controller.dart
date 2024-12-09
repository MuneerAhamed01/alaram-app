import 'dart:async';
import 'package:get/get.dart';
import 'package:alarm/alarm.dart';
import 'package:alaram_app/utils/permissions.dart';
import 'package:alaram_app/models/alarm_model.dart';
import 'package:alaram_app/repostiory/alarm_repository.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AlarmController extends GetxController {
  RxBool isLoadingAlarms = false.obs;

  List<AlarmModel> alarms = [];

  bool hasError = false;

  StreamSubscription<AlarmSettings>? ringSubscription;
  StreamSubscription<int>? updateSubscription;

  @override
  void onInit() {
    super.onInit();
    AlarmPermissions.checkNotificationPermission();
    if (Alarm.android) {
      AlarmPermissions.checkAndroidScheduleExactAlarmPermission();
    }
    ringSubscription = Alarm.ringStream.stream.listen(listenToAlarm);

    updateSubscription ??= Alarm.updateStream.stream.listen(listenToUpdate);

    getAllAlarms();
  }

  Future<void> getAllAlarms([
    bool silentUpdate = false,
  ]) async {
    isLoadingAlarms.value = true;
    alarms = await AlarmRepository.instance.getAllAlarms();
    alarms.sort((a, b) =>
        a.alarmSettings!.dateTime.isBefore(b.alarmSettings!.dateTime) ? 0 : 1);

    isLoadingAlarms.value = false;
  }

  void listenToAlarm(AlarmSettings alarm) {
    // Navigate
  }

  void listenToUpdate(int alarm) async {
    await getAllAlarms(true);

    // _storeNewAlarmWhileAdding();
  }

  // Future<void> _storeNewAlarmWhileAdding() async {
  //   AlarmRepository.instance.addAllAlarm(alarms);
  // }

  @override
  void onClose() {
    ringSubscription?.cancel();
    updateSubscription?.cancel();
    super.onClose();
  }
}
