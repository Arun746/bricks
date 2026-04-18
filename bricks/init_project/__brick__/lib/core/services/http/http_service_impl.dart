import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wrench_and_bolts/core/services/http/http_service.dart';
import 'package:wrench_and_bolts/core/services/http/interceptor/session_interceptor.dart';

final httpServiceProvider = Provider<HttpService>((ref) {
  return HttpServiceImpl();
});

class HttpServiceImpl implements HttpService {
  final dio = Dio();
  HttpServiceImpl() {
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
          error: true,
          compact: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false));
    }
    dio.interceptors.add(TokenInterceptor(dio));
  }
  @override
  Future<Response> delete(
      {required String endpoint,
      required Map<String, String> headers,
      Map<String, dynamic>? queryParameters,
      Object? body}) async {
    try {
      final response = await dio.delete<String>(endpoint,
          data: body,
          queryParameters: queryParameters,
          options: Options(headers: headers));

      return response;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> get(
      {required String endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get<String>(endpoint,
          options: Options(headers: headers), queryParameters: queryParameters);
      return response;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> post(
      {required String endpoint,
      Map<String, String>? headers,
      FormData? formData,
      Map<String, dynamic>? queryParameters,
      Object? body}) async {
    try {
      late Object? data;
      if (formData != null) {
        data = formData;
      } else {
        data = body;
      }
      final response = await dio.post<String>(endpoint,
          data: data,
          options: Options(headers: headers),
          queryParameters: queryParameters);
      return response;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> put(
      {required String endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      FormData? formData,
      Object? body}) async {
    try {
      late Object? data;
      if (formData != null) {
        data = formData;
      } else {
        data = body;
      }
      final response = await dio.put<String>(endpoint,
          queryParameters: queryParameters,
          data: data,
          options: Options(headers: headers));
      return response;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> download(
      {required String savePath,
      required String endpoint,
      required Map<String, String> headers}) async {
    try {
      final response = await dio.download(endpoint, savePath,
          options: Options(headers: headers));
      return response;
    } catch (_) {
      rethrow;
    }
  }
}
