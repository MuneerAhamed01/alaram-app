import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:alarm/alarm.dart';
import 'package:alaram_app/models/countdown_model.dart';
import 'package:alaram_app/repository/countdown_repository.dart';

class CountdownController extends GetxController {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int totalSeconds = 0;
  bool isRunning = false;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startTimerIfActive();
  }

  Future<void> startTimerIfActive() async {
    final instanceOfRepo = CountdownRepository.instance;
    if (!instanceOfRepo.isActiveCountDown) return;
    final countDown = instanceOfRepo.currentCountDown;

    final durationBtwTime = countDown!.endTime.difference(DateTime.now());
    hours = durationBtwTime.inHours;
    minutes = durationBtwTime.inMinutes;
    seconds = durationBtwTime.inSeconds;
    totalSeconds = hours * 3600 + minutes * 60 + seconds;

    startTimer();
  }

  void startTimer() {
    if (totalSeconds > 0) {
      isRunning = true;
      update();

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (totalSeconds > 0) {
          totalSeconds--;
          hours = totalSeconds ~/ 3600;
          minutes = (totalSeconds % 3600) ~/ 60;
          seconds = totalSeconds % 60;
        } else {
          timer.cancel();
          isRunning = false;
        }
        update();
      });
    }
  }

  onStartTimer() {
    totalSeconds = hours * 3600 + minutes * 60 + seconds;
    startTimer();
    _enableNotificationForTheCountdown();
  }

  onDeleteTimer() {
    timer?.cancel();
    isRunning = false;
    hours = 0;
    minutes = 0;
    seconds = 0;
    totalSeconds = 0;
    CountdownRepository.instance.stopTheCountDown();
    update();
  }

  Future<void> _enableNotificationForTheCountdown() async {
    final Duration countDuration =
        Duration(days: 0, hours: hours, minutes: minutes, seconds: seconds);
    final CountdownModel countDown = CountdownModel(
      id: 1,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(countDuration),
    );

    countDown.settings = _buildAlarmSettings(DateTime.now().add(countDuration));
    await CountdownRepository.instance.startCountDown(countDown);
  }

  AlarmSettings _buildAlarmSettings(DateTime endDate) {
    final alarmSettings = AlarmSettings(
      id: 1,
      dateTime: endDate,
      vibrate: false,
      assetAudioPath: 'assets/ringtone/marimba.mp3',
      warningNotificationOnKill: Platform.isIOS,
      notificationSettings: const NotificationSettings(
        title: "Countdown completed",
        stopButton: 'Stop',
        icon: 'notification_icon',
        body: 'The count you have set is completed',
      ),
    );
    return alarmSettings;
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
