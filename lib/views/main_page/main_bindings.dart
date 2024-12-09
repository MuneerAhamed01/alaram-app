import 'package:get/get.dart';
import 'package:alaram_app/views/alarm/alarm_controller.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:alaram_app/views/main_page/main_controller.dart';
import 'package:alaram_app/views/countdown/contdown_controller.dart';

class AlarmBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController(), permanent: true);
    Get.put(CountdownController(), permanent: true);
    Get.put<AlarmController>(AlarmController(), permanent: true);
  }
}
