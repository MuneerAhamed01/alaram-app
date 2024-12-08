import 'package:get/get.dart';
import 'package:alaram_app/views/alarm/alarm_controller.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class AlarmBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmController>(() => AlarmController());
  }
}
