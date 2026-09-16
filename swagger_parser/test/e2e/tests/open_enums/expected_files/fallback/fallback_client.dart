// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/nusach.dart';
import '../models/shul.dart';
import '../models/source_kind.dart';

part 'fallback_client.g.dart';

@RestApi()
abstract class FallbackClient {
  factory FallbackClient(Dio dio, {String? baseUrl}) = _FallbackClient;

  @GET('/shuls')
  Future<Shul> listShuls({
    @Query('nusachim') List<Nusach>? nusachim,
  });

  @MultiPart()
  @POST('/schedules')
  Future<void> submitSchedule({
    @Part(name: 'source_kind') required SourceKind sourceKind,
  });
}
