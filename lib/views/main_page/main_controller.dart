import 'package:get/state_manager.dart';
import 'package:alaram_app/repository/countdown_repository.dart';

class MainController extends GetxController {
  Rx<int> selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    CountdownRepository.instance.isActiveCountDown
        ? selectedIndex.value = 1
        : 0;
  }

  void updateIndex(int index) {
    selectedIndex.value = index;
  }
}
