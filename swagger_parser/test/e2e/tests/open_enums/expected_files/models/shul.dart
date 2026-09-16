// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'nusach.dart';
import 'priority.dart';

part 'shul.g.dart';

@JsonSerializable()
class Shul {
  const Shul({
    required this.nusachim,
    required this.priority,
    this.main,
  });

  factory Shul.fromJson(Map<String, Object?> json) => _$ShulFromJson(json);

  final List<Nusach> nusachim;
  final Nusach? main;
  final Priority priority;

  Map<String, Object?> toJson() => _$ShulToJson(this);
}
