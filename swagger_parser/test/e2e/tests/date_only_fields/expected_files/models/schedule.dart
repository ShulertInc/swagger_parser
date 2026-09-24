// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  const Schedule({
    required this.startsOn,
    required this.createdAt,
    this.endsOn,
    this.holidays,
  });

  factory Schedule.fromJson(Map<String, Object?> json) =>
      _$ScheduleFromJson(json);

  @_DateOnlyConverter()
  @JsonKey(name: 'starts_on')
  final DateTime startsOn;
  @_DateOnlyConverter()
  @JsonKey(name: 'ends_on')
  final DateTime? endsOn;
  @_DateOnlyConverter()
  final List<DateTime>? holidays;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$ScheduleToJson(this);
}

class _DateOnlyConverter implements JsonConverter<DateTime, String> {
  const _DateOnlyConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.toIso8601String().substring(0, 10);
}
