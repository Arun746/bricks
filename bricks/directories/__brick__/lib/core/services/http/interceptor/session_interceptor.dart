import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../routing/routing.dart';

const sessionExpireMessage = 'Session expired';

class TokenInterceptor implements Interceptor {
  final invalidMessage = 'Invalid token type';
  final refreshTokenpath = '/auth/refresh';
  final Dio dio;
  TokenInterceptor(this.dio);
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      final isRefreshing =
          err.requestOptions.uri.path.contains(refreshTokenpath);

      if (isRefreshing) {
        handler.next(_sessionExpireException(err.requestOptions));
        return;
      }

      if (err.response?.statusCode == 401) {
        late String message;
        try {
          message = jsonDecode(err.response?.data)['message'] ?? '';
        } catch (_) {
          message = '';
        }

        if (message == invalidMessage) {
          try {
            final newToken = await getRefreshedAccessToken();
            if (newToken != null && newToken.isNotEmpty) {
              err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final retryResponse = await dio.fetch(err.requestOptions);
              handler.resolve(retryResponse);
            } else {
              handler.next(_sessionExpireException(err.requestOptions));
            }
          } catch (error) {
            handler.next(_sessionExpireException(err.requestOptions));
          }
        } else {
          handler.next(_sessionExpireException(err.requestOptions));
        }
      } else {
        handler.next(err);
      }
    } catch (_) {
      handler.next(err);
    }
  }

  DioException _sessionExpireException(RequestOptions requestOptions) {
    // Call logout when session expires
    _handleSessionExpiration();
    return DioException(
        requestOptions: requestOptions,
        message: sessionExpireMessage,
        response: Response(
            requestOptions: requestOptions,
            statusCode: 401,
            data: jsonEncode({"message": sessionExpireMessage}),
            statusMessage: sessionExpireMessage));
  }

  void _handleSessionExpiration() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      //logout logic here
    } else {
     //clean and navigate to login when context is not available
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  Future<String?> getRefreshedAccessToken() async {
    //call refresh token api and return new access token
    return '';
  }
}
