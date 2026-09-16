// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

extension type const Nusach(String json) implements String {
  static const ashkenaz = Nusach('ashkenaz');
  static const edotHamizrach = Nusach('edot hamizrach');

  static const values = <Nusach>[ashkenaz, edotHamizrach];

  factory Nusach.fromJson(String json) => Nusach(json);

  String toJson() => json;

  bool get isKnown => values.contains(this);
}
