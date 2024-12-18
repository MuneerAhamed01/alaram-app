import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:alaram_app/widgets/alarm_tile.dart';
import 'package:alaram_app/views/alarm/alarm_controller.dart';
import 'package:alaram_app/widgets/add_alarm_sheet/add_alarm_widget.dart';

const kAlarmRoute = '/alarm';

class AlarmScreen extends GetWidget<AlarmController> {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alarms',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 20),
            GetBuilder<AlarmController>(
              builder: (_) {
                if (controller.isLoadingAlarms) return _buildLoadingIndicator();

                if (controller.alarms.isEmpty) return _buildEmptyState(context);

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.alarms.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await AddAlarmWidget.showBottomSheet(
                          alarm: controller.alarms[index],
                        );
                        controller.getAllAlarms(true);
                      },
                      child: AlarmTile(
                        alarm: controller.alarms[index],
                        isEditMode: controller.isEditMode,
                        onTapDelete: () {
                          controller.deleteAlarm(controller.alarms[index].id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.alarm_off,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              'No alarms set',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Center _buildLoadingIndicator() =>
      const Center(child: CircularProgressIndicator());
}
