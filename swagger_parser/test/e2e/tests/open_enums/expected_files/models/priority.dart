// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

extension type const Priority(int json) implements int {
  static const value1 = Priority(1);
  static const value2 = Priority(2);

  static const values = <Priority>[value1, value2];

  factory Priority.fromJson(int json) => Priority(json);

  int toJson() => json;

  bool get isKnown => values.contains(this);
}
