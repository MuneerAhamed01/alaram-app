import 'package:alarm/alarm.dart';

class CountdownModel {
  final int id;
  AlarmSettings? settings;
  final DateTime startTime;
  final DateTime endTime;
  CountdownModel({
    required this.id,
    this.settings,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
    };
  }

  DateTime calculateEndTime(Duration duration) {
    return startTime.add(duration);
  }

  factory CountdownModel.fromMap(Map<String, dynamic> map) {
    return CountdownModel(
      id: map['id'] as int,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
    );
  }

  CountdownModel copyWith({
    int? id,
    AlarmSettings? settings,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return CountdownModel(
      id: id ?? this.id,
      settings: settings ?? this.settings,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
