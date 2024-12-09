import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:alaram_app/themes/colors.dart';
import 'package:alaram_app/widgets/add_alarm_sheet/add_alarm_controller.dart';

class AddAlarmWidget extends StatelessWidget {
  const AddAlarmWidget({super.key});

  static Future<void> showBottomSheet() async {
    return await Get.bottomSheet(
      const AddAlarmWidget(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddAlarmController>(
      init: AddAlarmController(),
      builder: (controller) {
        return Container(
          height: Get.height * 0.8,
          color: const Color(0xFF1C1C1E),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 20),

                // Time Picker
                _buildTimer(controller),
                const SizedBox(height: 20),

                // Settings
                _buildSettings(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _buildSettings(AddAlarmController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // _buildSettingItem(
          //   'Repeat',
          //   trailing: Row(
          //     children: [
          //       const Text(
          //         'Never',
          //         style: TextStyle(
          //           color: Colors.grey,
          //         ),
          //       ),
          //       const SizedBox(width: 8),
          //       Icon(
          //         CupertinoIcons.right_chevron,
          //         size: 16,
          //         color: Colors.grey.shade600,
          //       ),
          //     ],
          //   ),
          // ),
          _buildDivider(),
          _buildSettingItem(
            'Label',
            trailing: SizedBox(
              width: 200,
              child: TextField(
                controller: controller.labelController,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          _buildDivider(),
          // _buildSettingItem(
          //   'Snooze',
          //   trailing: CupertinoSwitch(
          //     value: true,
          //     activeColor: Colors.green,
          //     onChanged: (value) {
          //       // setState(() {
          //       //   snoozeEnabled = value;
          //       // });
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  SizedBox _buildTimer(AddAlarmController controller) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hours
          SizedBox(
            width: 80,
            child: CupertinoPicker(
              scrollController: controller.hourExtend,
              itemExtent: 64,
              looping: true,
              children: List.generate(
                12,
                (index) => Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              onSelectedItemChanged: (value) {
                // setState(() {
                //   selectedHour = value + 1;
                // });
              },
            ),
          ),
          // Minutes
          SizedBox(
            width: 80,
            child: CupertinoPicker(
              scrollController: controller.minuteExtend,
              itemExtent: 64,
              children: List.generate(
                60,
                (index) => Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              onSelectedItemChanged: (value) {
                // setState(() {
                //   selectedMinute = value;
                // });
              },
            ),
          ),
          // AM/PM
          SizedBox(
            width: 80,
            child: CupertinoPicker(
              scrollController: controller.amOrPmExtend,
              itemExtent: 64,
              children: const [
                Center(
                  child: Text(
                    'AM',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Center(
                  child: Text(
                    'PM',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
              onSelectedItemChanged: (value) {
                // setState(() {
                //   isAM = value == 0;
                // });
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: MyColors.textButtonColor,
                fontSize: 17,
              ),
            ),
          ),
          const Text(
            'Add Alarm',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () async {
              await Get.find<AddAlarmController>().saveAlarm();
              Get.back();
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: MyColors.textButtonColor,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      color: Color(0xFF3C3C3E),
      indent: 16,
      endIndent: 16,
    );
  }
}
