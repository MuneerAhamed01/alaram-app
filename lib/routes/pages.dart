import 'package:alaram_app/views/main_page/main_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:alaram_app/views/main_page/main_bindings.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class Routes {
  List<GetPage> getGetXPages() {
    return [
      GetPage(
        name: kMainRoute,
        page: () => MainPage(),
        transition: Transition.fadeIn,
        binding: AlarmBindings(),
      ),
    ];
  }
}
