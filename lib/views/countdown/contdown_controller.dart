import 'dart:async';
import 'package:get/get.dart';

class CountdownController extends GetxController {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int totalSeconds = 0;
  bool isRunning = false;
  Timer? timer;

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
  }

  onDeleteTimer() {
    timer?.cancel();
    isRunning = false;
    hours = 0;
    minutes = 0;
    seconds = 0;
    totalSeconds = 0;
    update();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
