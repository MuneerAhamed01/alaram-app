import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:alaram_app/themes/colors.dart';
import 'package:alaram_app/widgets/alarm_tile.dart';
import 'package:alaram_app/views/alarm/alarm_controller.dart';
import 'package:alaram_app/widgets/add_alarm_sheet/add_alarm_widget.dart';

const kAlarmRoute = '/alarm';

class AlarmScreen extends GetWidget<AlarmController> {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: _buildAppBarLeading(),
        actions: [_buildAppBarAction()],
      ),
      body: SafeArea(
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
              Obx(
                () {
                  if (controller.isLoadingAlarms.value) {
                    return const CircularProgressIndicator();
                  }
                  if (controller.alarms.isEmpty) {
                    return Center(
                      child: Text(
                        'No alarms set',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.alarms.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return AlarmTile(
                        alarm: controller.alarms[index],
                        onPressed: () {
                          // _buildAddAlarm(controller.alarms[index]);
                        },
                        onDismissed: () {},
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExampleAlarmHomeShortcutButton(
                refreshAlarms: controller.getAllAlarms),
            FloatingActionButton(
              onPressed: () {
                _buildAddAlarm(null);
              },
              child: const Icon(Icons.alarm_add_rounded, size: 33),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  IconButton _buildAppBarAction() {
    return IconButton(
      onPressed: () {
        AddAlarmWidget.showBottomSheet();
      },
      icon: Icon(
        Icons.add,
        color: MyColors.textButtonColor,
      ),
      iconSize: 30,
    );
  }

  TextButton _buildAppBarLeading() {
    return TextButton(
      onPressed: () {},
      child: Text(
        'Edit',
        style: TextStyle(
          fontSize: 18,
          color: MyColors.textButtonColor,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Future<void> _buildAddAlarm(AlarmSettings? settings) async {
    await showModalBottomSheet<bool?>(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: ExampleAlarmEditScreen(alarmSettings: settings),
        );
      },
    );

    // if (res != null && res == true) unawaited(loadAlarms());
  }
}

const version = '4.1.1';

// class ExampleAlarmHomeScreen extends StatefulWidget {
//   const ExampleAlarmHomeScreen({super.key});

//   @override
//   State<ExampleAlarmHomeScreen> createState() => _ExampleAlarmHomeScreenState();
// }

// class _ExampleAlarmHomeScreenState extends State<ExampleAlarmHomeScreen> {
//   List<AlarmSettings> alarms = [];

//   static StreamSubscription<AlarmSettings>? ringSubscription;
//   static StreamSubscription<int>? updateSubscription;

//   @override
//   void initState() {
//     super.initState();

//     unawaited(loadAlarms());
//     ringSubscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
//     updateSubscription ??= Alarm.updateStream.stream.listen((_) {
//       unawaited(loadAlarms());
//     });
//   }

//   Future<void> loadAlarms() async {
//     final updatedAlarms = await Alarm.getAlarms();
//     updatedAlarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
//     setState(() {
//       alarms = updatedAlarms;
//     });
//   }

//   Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute<void>(
//         builder: (context) =>
//             ExampleAlarmRingScreen(alarmSettings: alarmSettings),
//       ),
//     );
//     unawaited(loadAlarms());
//   }

//   Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
//     final res = await showModalBottomSheet<bool?>(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       builder: (context) {
//         return FractionallySizedBox(
//           heightFactor: 0.75,
//           child: ExampleAlarmEditScreen(alarmSettings: settings),
//         );
//       },
//     );

//     if (res != null && res == true) unawaited(loadAlarms());
//   }

//   Future<void> launchReadmeUrl() async {
//     final url = Uri.parse('https://pub.dev/packages/alarm/versions/$version');
//     // await launchUrl(url);
//   }

//   @override
//   void dispose() {
//     ringSubscription?.cancel();
//     updateSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('alarm $version'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.menu_book_rounded),
//             onPressed: launchReadmeUrl,
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: alarms.isNotEmpty
//             ? ListView.separated(
//                 itemCount: alarms.length,
//                 separatorBuilder: (context, index) => const Divider(height: 1),
//                 itemBuilder: (context, index) {
//                   return AlarmTile(
//                     key: Key(alarms[index].id.toString()),
//                     alarm: alarms[index],
//                     title: TimeOfDay(
//                       hour: alarms[index].dateTime.hour,
//                       minute: alarms[index].dateTime.minute,
//                     ).format(context),
//                     onPressed: () => navigateToAlarmScreen(alarms[index]),
//                     onDismissed: () {
//                       Alarm.stop(alarms[index].id).then((_) => loadAlarms());
//                     },
//                   );
//                 },
//               )
//             : Center(
//                 child: Text(
//                   'No alarms set',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//               ),
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             ExampleAlarmHomeShortcutButton(refreshAlarms: loadAlarms),
//             FloatingActionButton(
//               onPressed: () => navigateToAlarmScreen(null),
//               child: const Icon(Icons.alarm_add_rounded, size: 33),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }

class ExampleAlarmRingScreen extends StatelessWidget {
  const ExampleAlarmRingScreen({required this.alarmSettings, super.key});

  final AlarmSettings alarmSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'You alarm (${alarmSettings.id}) is ringing...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text('🔔', style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    final now = DateTime.now();
                    Alarm.set(
                      alarmSettings: alarmSettings.copyWith(
                        dateTime: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                        ).add(const Duration(minutes: 1)),
                      ),
                    ).then((_) {
                      if (context.mounted) Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Snooze',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    Alarm.stop(alarmSettings.id).then((_) {
                      if (context.mounted) Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Stop',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleAlarmEditScreen extends StatefulWidget {
  const ExampleAlarmEditScreen({super.key, this.alarmSettings});

  final AlarmSettings? alarmSettings;

  @override
  State<ExampleAlarmEditScreen> createState() => _ExampleAlarmEditScreenState();
}

class _ExampleAlarmEditScreenState extends State<ExampleAlarmEditScreen> {
  bool loading = false;

  late bool creating;
  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late double fadeDuration;
  late String assetAudio;

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = null;
      fadeDuration = 0;
      assetAudio = 'assets/ringtone/marimba.mp3';
    } else {
      selectedDateTime = widget.alarmSettings!.dateTime;
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volume = widget.alarmSettings!.volume;
      fadeDuration = widget.alarmSettings!.fadeDuration;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    switch (difference) {
      case 0:
        return 'Today';
      case 1:
        return 'Tomorrow';
      case 2:
        return 'After tomorrow';
      default:
        return 'In $difference days';
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        final now = DateTime.now();
        selectedDateTime = now.copyWith(
          hour: res.hour,
          minute: res.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
        : widget.alarmSettings!.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: volume,
      fadeDuration: fadeDuration,
      assetAudioPath: assetAudio,
      warningNotificationOnKill: Platform.isIOS,
      notificationSettings: NotificationSettings(
        title: 'Alarm example',
        body: 'Your alarm ($id) is ringing',
        stopButton: 'Stop the alarm',
        icon: 'notification_icon',
      ),
    );
    return alarmSettings;
  }

  void saveAlarm() {
    if (loading) return;
    setState(() => loading = true);
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res && mounted) Navigator.pop(context, true);
      setState(() => loading = false);
    });
  }

  void deleteAlarm() {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res && mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.blueAccent),
              ),
            ),
            TextButton(
              onPressed: saveAlarm,
              child: loading
                  ? const CircularProgressIndicator()
                  : Text(
                      'Save',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.blueAccent),
                    ),
            ),
          ],
        ),
        Text(
          getDay(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.blueAccent.withOpacity(0.8)),
        ),
        RawMaterialButton(
          onPressed: pickTime,
          fillColor: Colors.grey[200],
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              TimeOfDay.fromDateTime(selectedDateTime).format(context),
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Colors.blueAccent),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Loop alarm audio',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Switch(
              value: loopAudio,
              onChanged: (value) => setState(() => loopAudio = value),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Vibrate',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Switch(
              value: vibrate,
              onChanged: (value) => setState(() => vibrate = value),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sound',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            DropdownButton(
              value: assetAudio,
              items: const [
                DropdownMenuItem<String>(
                  value: 'assets/ringtone/marimba.mp3',
                  child: Text('Marimba'),
                ),
                DropdownMenuItem<String>(
                  value: 'assets/nokia.mp3',
                  child: Text('Nokia'),
                ),
                DropdownMenuItem<String>(
                  value: 'assets/mozart.mp3',
                  child: Text('Mozart'),
                ),
                DropdownMenuItem<String>(
                  value: 'assets/star_wars.mp3',
                  child: Text('Star Wars'),
                ),
                DropdownMenuItem<String>(
                  value: 'assets/one_piece.mp3',
                  child: Text('One Piece'),
                ),
              ],
              onChanged: (value) => setState(() => assetAudio = value!),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Custom volume',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Switch(
              value: volume != null,
              onChanged: (value) => setState(() => volume = value ? 0.5 : null),
            ),
          ],
        ),
        if (volume != null)
          SizedBox(
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  volume! > 0.7
                      ? Icons.volume_up_rounded
                      : volume! > 0.1
                          ? Icons.volume_down_rounded
                          : Icons.volume_mute_rounded,
                ),
                Expanded(
                  child: Slider(
                    value: volume!,
                    onChanged: (value) {
                      setState(() => volume = value);
                    },
                  ),
                ),
              ],
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fade duration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            DropdownButton<double>(
              value: fadeDuration,
              items: List.generate(
                6,
                (index) => DropdownMenuItem<double>(
                  value: index * 3.0,
                  child: Text('${index * 3}s'),
                ),
              ),
              onChanged: (value) => setState(() => fadeDuration = value!),
            ),
          ],
        ),
        if (!creating)
          TextButton(
            onPressed: deleteAlarm,
            child: Text(
              'Delete Alarm',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.red),
            ),
          ),
        const SizedBox(),
      ],
    );
  }
}

class ExampleAlarmHomeShortcutButton extends StatefulWidget {
  const ExampleAlarmHomeShortcutButton({
    required this.refreshAlarms,
    super.key,
  });

  final void Function() refreshAlarms;

  @override
  State<ExampleAlarmHomeShortcutButton> createState() =>
      _ExampleAlarmHomeShortcutButtonState();
}

class _ExampleAlarmHomeShortcutButtonState
    extends State<ExampleAlarmHomeShortcutButton> {
  bool showMenu = false;

  Future<void> onPressButton(int delayInHours) async {
    var dateTime = DateTime.now().add(Duration(hours: delayInHours));
    double? volume;

    if (delayInHours != 0) {
      dateTime = dateTime.copyWith(second: 0, millisecond: 0);
      volume = 0.5;
    }

    setState(() => showMenu = false);

    final alarmSettings = AlarmSettings(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      dateTime: dateTime,
      assetAudioPath: 'assets/ringtone/marimba.mp3',
      volume: volume,
      notificationSettings: NotificationSettings(
        title: 'Alarm example',
        body: 'Shortcut button alarm with delay of $delayInHours hours',
        icon: 'notification_icon',
      ),
      warningNotificationOnKill: Platform.isIOS,
    );

    await Alarm.set(alarmSettings: alarmSettings);

    widget.refreshAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onLongPress: () {
            setState(() => showMenu = true);
          },
          child: FloatingActionButton(
            onPressed: () => onPressButton(0),
            backgroundColor: Colors.red,
            heroTag: null,
            child: const Text('RING NOW', textAlign: TextAlign.center),
          ),
        ),
        if (showMenu)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () => onPressButton(24),
                child: const Text('+24h'),
              ),
              TextButton(
                onPressed: () => onPressButton(36),
                child: const Text('+36h'),
              ),
              TextButton(
                onPressed: () => onPressButton(48),
                child: const Text('+48h'),
              ),
            ],
          ),
      ],
    );
  }
}
