// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/shuls_client.dart';
import 'clients/status_client.dart';

/// Test API for generateErrorStatuses `v1.0.0`
class RestClient {
  RestClient(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '1.0.0';

  ShulsClient? _shuls;
  StatusClient? _status;

  ShulsClient get shuls => _shuls ??= ShulsClient(_dio, baseUrl: _baseUrl);

  StatusClient get status => _status ??= StatusClient(_dio, baseUrl: _baseUrl);
}
