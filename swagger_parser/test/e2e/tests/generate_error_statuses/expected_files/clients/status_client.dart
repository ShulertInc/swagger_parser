// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'status_client.g.dart';

@RestApi()
abstract class StatusClient {
  factory StatusClient(Dio dio, {String? baseUrl}) = _StatusClient;

  static const Set<int> statusErrorStatuses = {503};

  @GET('/status')
  Future<void> status();
}
