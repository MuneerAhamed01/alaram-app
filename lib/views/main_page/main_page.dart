import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:alaram_app/themes/colors.dart';
import 'package:alaram_app/views/alarm/alarm_screen.dart';
import 'package:alaram_app/views/alarm/alarm_controller.dart';
import 'package:alaram_app/views/main_page/main_controller.dart';
import 'package:alaram_app/views/countdown/countdown_screen.dart';
import 'package:alaram_app/widgets/add_alarm_sheet/add_alarm_widget.dart';

const String kMainRoute = '/main';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  final List<Widget> screens = const [
    AlarmScreen(),
    CountdownScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: controller.selectedIndex.value == 0
            ? AppBar(
                leadingWidth: 70,
                leading: _buildAppBarLeading(),
                actions: [_buildAppBarAction(), const SizedBox(width: 10)],
              )
            : null,
        body: screens[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: MyColors.textButtonColor,
          onTap: (index) {
            controller.updateIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: 'Alarm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Countdown',
            ),
          ],
        ),
      );
    });
  }

  IconButton _buildAppBarAction() {
    final controller = Get.find<AlarmController>();
    return IconButton(
      onPressed: () async {
        await AddAlarmWidget.showBottomSheet();
        controller.getAllAlarms(true);
      },
      icon: Icon(
        Icons.add,
        color: MyColors.textButtonColor,
      ),
      iconSize: 30,
    );
  }

  Widget _buildAppBarLeading() {
    return GetBuilder<AlarmController>(
      builder: (controller) {
        return Visibility(
          visible: controller.alarms.isNotEmpty,
          child: TextButton(
            onPressed: () {
              controller.updateEdit();
            },
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: 18,
                color: MyColors.textButtonColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
