import 'package:alarm/alarm.dart';
import 'package:get_storage/get_storage.dart';
import 'package:alaram_app/models/countdown_model.dart';

class CountdownRepository {
  CountdownRepository._();

  CountdownModel? currentCountDown;

  bool get isActiveCountDown => currentCountDown != null;

  static const String _kCountDownBox = 'countdown-box';

  static CountdownRepository instance = CountdownRepository._();

  static initRepo() async {
    await GetStorage.init('countDown');
    await instance.getCountDownIfActive();
  }

  final GetStorage countDownBox = GetStorage('countDown');

  Future<void> startCountDown(CountdownModel countDown) async {
    await Alarm.set(alarmSettings: countDown.settings!);
    await countDownBox.write(_kCountDownBox, countDown.toMap());

    currentCountDown = countDown;
  }

  Future<CountdownModel?> getCountDownIfActive() async {
    final countDown = countDownBox.read(_kCountDownBox);

    if (countDown == null) return null;

    final countToModel = CountdownModel.fromMap(countDown);

    if (countToModel.endTime.isBefore(DateTime.now())) {
      await countDownBox.erase();
      return null;
    }

    final settings = await Alarm.getAlarm(countToModel.id);
    countToModel.settings = settings;

    currentCountDown = countToModel;

    return countToModel;
  }

  Future<void> stopTheCountDown() async {
    final countDown = countDownBox.read(_kCountDownBox);
    final countToModel = CountdownModel.fromMap(countDown);
    await Alarm.stop(countToModel.id);
    countDownBox.read(_kCountDownBox);
  }
}
