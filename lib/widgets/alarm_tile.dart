import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:alaram_app/models/alarm_model.dart';

class AlarmTile extends StatelessWidget {
  const AlarmTile({
    required this.onPressed,
    super.key,
    this.onDismissed,
    this.isEditMode = false,
    required this.alarm,
  });

  final AlarmModel alarm;
  final void Function() onPressed;
  final void Function()? onDismissed;
  final bool isEditMode;

  String get title {
    return TimeOfDay(
      hour: alarm.alarmSettings!.dateTime.hour,
      minute: alarm.alarmSettings!.dateTime.minute,
    ).format(Get.context!);
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Visibility(
          visible: isEditMode,
          child: const CircleAvatar(
            radius: 12,
            backgroundColor: Colors.red,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Divider(
                thickness: 1.5,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  alarm.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Visibility(
          visible: !isEditMode,
          child: _buildSwitch(),
        )
      ],
    );
  }

  Switch _buildSwitch() {
    return Switch(
      value: false,
      onChanged: (_) {},
      activeColor: Colors.white,
      activeTrackColor: Colors.green,
    );
  }
}
