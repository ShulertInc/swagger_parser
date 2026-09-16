// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

extension type const SourceKind(String json) implements String {
  static const pdf = SourceKind('pdf');
  static const externalUrl = SourceKind('external-url');

  static const values = <SourceKind>[pdf, externalUrl];

  factory SourceKind.fromJson(String json) => SourceKind(json);

  String toJson() => json;

  bool get isKnown => values.contains(this);
}
