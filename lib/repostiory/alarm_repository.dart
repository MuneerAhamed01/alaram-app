import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:get_storage/get_storage.dart';
import 'package:alaram_app/models/alarm_model.dart';

class AlarmRepository {
  AlarmRepository._();

  static AlarmRepository instance = AlarmRepository._();

  static const String _kAlarmBox = 'alarms';

  final GetStorage alarmBox = GetStorage();

  Future<void> addAlarm(AlarmModel alarm) async {
    final alarmList = alarmBox.read<List>(_kAlarmBox) ?? [];
    await Alarm.set(alarmSettings: alarm.alarmSettings!);
    final newList = [...alarmList, alarm.toMap()];
    await alarmBox.write(_kAlarmBox, newList);
  }

  FutureOr<List<AlarmModel>> getAllAlarms([bool refresh = false]) async {
    final alarmList = alarmBox.read<List>(_kAlarmBox);

    final alarmModels =
        alarmList?.map((e) => AlarmModel.fromMap(e)).toList() ?? [];

    final alarmsSettings = await Alarm.getAlarms();

    for (var alarm in alarmModels) {
      final alarmIndex = alarmsSettings.indexWhere((e) => e.id == alarm.id);
      if (alarmIndex != -1) {
        alarm.alarmSettings = alarmsSettings[alarmIndex];
      }
    }

    return alarmModels;
  }

  Future<void> updateAlarm(AlarmModel alarm) async {
    final alarmList = alarmBox.read<List>(_kAlarmBox) ?? [];
    final localAlarmList = alarmList.map((e) => AlarmModel.fromMap(e)).toList();
    final indexOfAlarmEditing =
        localAlarmList.indexWhere((e) => e.id == alarm.id);
    await Alarm.stop(alarm.id);
    await Alarm.set(alarmSettings: alarm.alarmSettings!);
    localAlarmList[indexOfAlarmEditing] = alarm;
    await alarmBox.write(_kAlarmBox, localAlarmList);
  }

  Future<void> deleteAlarm(int id) async {
    await Alarm.stop(id);
    final alarmList = alarmBox.read<List>(_kAlarmBox) ?? [];
    final localAlarmList = alarmList.map((e) => AlarmModel.fromMap(e)).toList();
    localAlarmList.removeWhere((e) => e.id == id);
    await alarmBox.write(_kAlarmBox, localAlarmList);
  }
}
