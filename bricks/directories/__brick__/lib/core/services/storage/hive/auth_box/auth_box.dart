import 'package:hive_flutter/hive_flutter.dart';

class AuthBox {
  static const boxKey = 'auth';
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';

  static Future<void> open() async {
    await Hive.openBox(boxKey);
  }

  static Future<void> close() async {
    await Hive.box(boxKey).close();
  }

  static isOpen() => Hive.isBoxOpen(boxKey);
  static Future<int> clear() async {
    return await Hive.box(boxKey).clear();
  }

  static Future<void> setAccessToken(String authAccessToken) async {
    try {
      await Hive.box(boxKey).put(accessToken, authAccessToken);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> setRefreshToken(String authRefreshToken) async {
    try {
      await Hive.box(boxKey).put(refreshToken, authRefreshToken);
    } catch (e) {
      rethrow;
    }
  }

  static String? getAccessToken() {
    try {
      return Hive.box(boxKey).get(accessToken);
    } catch (e) {
      rethrow;
    }
  }

  static String? getRefreshToken() {
    try {
      return Hive.box(boxKey).get(refreshToken);
    } catch (e) {
      rethrow;
    }
  }
}
