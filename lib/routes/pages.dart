import 'package:alaram_app/views/alarm/alarm_screen.dart';
import 'package:alaram_app/views/alarm/alarm_bindings.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class Routes {
  List<GetPage> getGetXPages() {
    return [
      GetPage(
        name: kAlarmRoute,
        page: () => const AlarmScreen(),
        transition: Transition.fadeIn,
        binding: AlarmBindings(),
      ),
    ];
  }
}
