// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'submission.g.dart';

@JsonSerializable()
class Submission {
  const Submission({
    required this.name,
    required this.note,
    required this.quoted,
    required this.tags,
    this.count,
    this.startsAt,
  });

  factory Submission.fromJson(Map<String, Object?> json) =>
      _$SubmissionFromJson(json);

  final String name;
  final String? note;
  final String quoted;
  final List<String> tags;
  final int? count;
  final DateTime? startsAt;

  Map<String, Object?> toJson() => _$SubmissionToJson(this);
  static const int nameMaxLength = 255;
  static const String namePattern = '\\S';
  static const int noteMaxLength = 1000;
  static const int quotedMinLength = 2;
  static const String quotedPattern = '^[^\'"\$\\\\]*\$';
  static const int tagsMinItems = 1;
  static const bool tagsUniqueItems = true;
  static const int countMin = 1;
  static const int countMax = 10;
  static const String startsAtPattern = '^2';
}

extension SubmissionValidationX on Submission {
  bool validate() {
    try {
      if (name.runes.length > Submission.nameMaxLength) {
        return false;
      }
    } catch (e) {
      return false;
    }
    try {
      if (!RegExp(Submission.namePattern, unicode: true).hasMatch(name)) {
        return false;
      }
    } catch (e) {
      return false;
    }
    try {
      if (note != null && note!.runes.length > Submission.noteMaxLength) {
        return false;
      }
    } catch (e) {
      return false;
    }
    try {
      if (quoted.runes.length < Submission.quotedMinLength) {
        return false;
      }
    } catch (e) {
      return false;
    }
    try {
      if (!RegExp(Submission.quotedPattern, unicode: true).hasMatch(quoted)) {
        return false;
      }
    } catch (e) {
      return false;
    }
    try {
      if (tags.length < Submission.tagsMinItems) {
        return false;
      }
    } catch (e) {
      return false;
    }
    try {
      if (Submission.tagsUniqueItems && tags.toSet().length != tags.length) {
        return false;
      }
    } catch (e) {
      return false;
    }
    try {
      if (count != null && count! < Submission.countMin) {
        return false;
      }
    } catch (e) {
      return false;
    }
    try {
      if (count != null && count! > Submission.countMax) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return true;
  }
}
