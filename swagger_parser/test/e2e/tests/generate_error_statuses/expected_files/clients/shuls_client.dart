// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/shul.dart';

part 'shuls_client.g.dart';

@RestApi()
abstract class ShulsClient {
  factory ShulsClient(Dio dio, {String? baseUrl}) = _ShulsClient;

  static const Set<int> getShulErrorStatuses = {404, 429};
  static const Set<int> deleteShulErrorStatuses = {};

  @GET('/shuls/{id}')
  Future<Shul> getShul({
    @Path('id') required String id,
  });

  @DELETE('/shuls/{id}')
  Future<void> deleteShul({
    @Path('id') required String id,
  });
}
