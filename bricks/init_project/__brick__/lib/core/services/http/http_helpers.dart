// ignore_for_file: unrelated_type_equality_checks

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wrench_and_bolts/core/exceptions/network_exception.dart';
import 'package:wrench_and_bolts/core/services/storage/hive/auth_box/auth_box.dart';

class HttpHelpers {
  static Future<Map<String, String>> getHeader() async {
    return {
      'Authorization': 'Bearer ${AuthBox.getAccessToken() ?? ''}',
    };
  }

  static Future<void> setAuthToken(String accessToken) async {
    try {
      if (accessToken.isNotEmpty) {
        await AuthBox.setAccessToken(accessToken);
      }
    } catch (_) {
      rethrow;
    }
  }

  static Future<void> setRefreshToken(String refreshToken) async {
    try {
      if (refreshToken.isNotEmpty) {
        await AuthBox.setRefreshToken(refreshToken);
      }
    } catch (_) {
      rethrow;
    }
  }

  static Future<bool> checkNetworkConnection() async {
    try {
      var result = await (Connectivity().checkConnectivity());
      // Handle both List<ConnectivityResult> (new versions) and ConnectivityResult (old versions)
      List<ConnectivityResult> connectivityResults;
      // ignore: unnecessary_type_check
      if (result is List<ConnectivityResult>) {
        connectivityResults = result;
      } else {
        connectivityResults = [result as ConnectivityResult];
      }

      // Check if any of the results indicate a connection
      bool hasConnection = connectivityResults.any((result) =>
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.other);

      if (hasConnection) {
        return true;
      } else {
        throw NetworkException();
      }
    } catch (_) {
      rethrow;
    }
  }
}
