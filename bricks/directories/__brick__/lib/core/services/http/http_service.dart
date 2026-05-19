import 'package:dio/dio.dart';

abstract class HttpService {
  Future<Response> get(
      {required String endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters});
  Future<Response> post(
      {required String endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      FormData? formData,
      Object? body});
  Future<Response> put(
      {required String endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      FormData? formData,
      Object? body});
  Future<Response> delete({
    Map<String, dynamic>? queryParameters,
    required String endpoint,
    required Map<String, String> headers,
    Object? body,
  });
  Future<Response> download({
    required String endpoint,
    required String savePath,
    required Map<String, String> headers,
  });
}
