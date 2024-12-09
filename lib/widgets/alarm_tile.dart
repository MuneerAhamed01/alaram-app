import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:alaram_app/models/alarm_model.dart';

class AlarmTile extends StatelessWidget {
  const AlarmTile({
    super.key,
    this.isEditMode = false,
    required this.alarm,
    this.onTapDelete,
  });

  final AlarmModel alarm;
  final void Function()? onTapDelete;
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
          child: GestureDetector(
            onTap: onTapDelete,
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
        ),
        if (isEditMode) const SizedBox(width: 10),
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
              if (alarm.label.isNotEmpty)
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
