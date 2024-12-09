import 'package:get/state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MainController extends GetxController {
  Rx<int> selectedIndex = 0.obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  // Example functions for each tab
  void onHomeTabSelected() {
    // Logic for Home tab
    print("Home Tab Selected");
  }

  void onProfileTabSelected() {
    // Logic for Profile tab
    print("Profile Tab Selected");
  }

  void onSettingsTabSelected() {
    // Logic for Settings tab
    print("Settings Tab Selected");
  }
}
