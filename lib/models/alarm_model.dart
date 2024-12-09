import 'package:alarm/alarm.dart';

class AlarmModel {
  AlarmSettings? alarmSettings;
  final int id;
  final String label;
  final bool isEnabled;
  final bool isDeleted;

  AlarmModel({
    required this.id,
    required this.label,
    required this.isEnabled,
    required this.isDeleted,
    this.alarmSettings,
  });

  AlarmModel copyWith({
    AlarmSettings? alarmSettings,
    String? label,
    bool? isEnabled,
    bool? isDeleted,
  }) {
    return AlarmModel(
      id: id,
      label: label ?? this.label,
      isEnabled: isEnabled ?? this.isEnabled,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
      'id': id,
      'isEnabled': isEnabled,
      'isDeleted': isDeleted,
    };
  }

  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      id: map['id'] as int,
      label: map['label'] as String,
      isEnabled: map['isEnabled'] as bool,
      isDeleted: map['isDeleted'] as bool,
    );
  }

  @override
  String toString() {
    return 'AlarmModel(alarmSettings: $alarmSettings, label: $label, isEnabled: $isEnabled, isDeleted: $isDeleted)';
  }
}
