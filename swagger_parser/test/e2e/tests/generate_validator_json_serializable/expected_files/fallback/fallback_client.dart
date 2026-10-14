// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/submission.dart';

part 'fallback_client.g.dart';

@RestApi()
abstract class FallbackClient {
  factory FallbackClient(Dio dio, {String? baseUrl}) = _FallbackClient;

  static const int searchSubmissionsQMaxLength = 200;
  static const int searchSubmissionsXDeviceIdMaxLength = 64;

  @POST('/submissions')
  Future<void> createSubmission({
    @Body() required Submission body,
  });

  @GET('/submissions')
  Future<void> searchSubmissions({
    @Query('q') required String q,
    @Header('X-Device-Id') String? xDeviceId,
    @Query('page') int? page,
  });
}
