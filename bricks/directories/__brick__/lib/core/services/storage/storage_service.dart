import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';


class StorageService {
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      await openBoxes();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> openBoxes() async {
    await AuthBox.open();
    await UserBox.open();
    await AppBox.open();
    await NotificationSettingsBox.open();
  }

  static Future<void> clearAll() async {
    try {
      await AuthBox.clear();
    } catch (error, stackTrace) {
      Zone.current.handleUncaughtError(error, stackTrace);
      rethrow;
    }
  }
}
