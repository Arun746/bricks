import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:wrench_and_bolts/core/services/storage/hive/auth_box/auth_box.dart';
import 'package:wrench_and_bolts/core/services/storage/hive/user_box/user_box.dart';
import 'package:wrench_and_bolts/core/services/storage/hive/address_box/address_box.dart';
import 'package:wrench_and_bolts/core/services/storage/hive/app_box/app_box.dart';
import 'package:wrench_and_bolts/core/services/notification/notification_settings_box.dart';

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
    await AddressBox.open();
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
