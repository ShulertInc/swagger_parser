// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'shul.g.dart';

@JsonSerializable()
class Shul {
  const Shul({
    required this.id,
  });

  factory Shul.fromJson(Map<String, Object?> json) => _$ShulFromJson(json);

  final String id;

  Map<String, Object?> toJson() => _$ShulToJson(this);
}
