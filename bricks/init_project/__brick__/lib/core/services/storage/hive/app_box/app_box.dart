import 'package:hive_flutter/hive_flutter.dart';
import 'package:wrench_and_bolts/core/utils/extensions/date_extensions.dart';

class AppBox {
  static const boxKey = 'app';
  static const firstInstallKey = 'firstInstall';
  static const showBiometricSetupOptionKey = 'showBiometricSetupOption';
  static const showOnboardingKey = 'showOnboarding';
  static const lastInAppReviewKey = 'lastInAppReview';

  static Future<void> setFCMToken(String token) async {
    try {
      await Hive.box(boxKey).put('fcmToken', token);
    } catch (e) {
      rethrow;
    }
  }

  static String? getFCMToken() {
    try {
      return Hive.box(boxKey).get('fcmToken');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> open() async {
    await Hive.openBox(boxKey);
  }

  static Future<void> close() async {
    await Hive.box(boxKey).close();
  }

  static isOpen() => Hive.isBoxOpen(boxKey);
  static Future<int> clear() async => await Hive.box(boxKey).clear();

  static Future<void> setFirstInstall(bool firstInstall) async {
    try {
      await Hive.box(boxKey).put(firstInstallKey, firstInstall == true ? 1 : 0);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> setShowBiometricSetupOption(bool show) async {
    try {
      await Hive.box(boxKey)
          .put(showBiometricSetupOptionKey, show == true ? 1 : 0);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> setShowOnboarding(bool show) async {
    try {
      await Hive.box(boxKey).put(showOnboardingKey, show == true ? 1 : 0);
    } catch (e) {
      rethrow;
    }
  }

  static bool getFirstInstall() {
    try {
      int? value = Hive.box(boxKey).get(firstInstallKey);
      if (value == null) {
        return true;
      } else {
        return value == 1;
      }
    } catch (e) {
      rethrow;
    }
  }

  static bool getShowBiometricSetupOption() {
    try {
      int? value = Hive.box(boxKey).get(showBiometricSetupOptionKey);
      if (value == null) {
        return true;
      } else {
        return value == 1;
      }
    } catch (e) {
      rethrow;
    }
  }

  static bool getShowOnboarding() {
    try {
      int? value = Hive.box(boxKey).get(showOnboardingKey);
      if (value == null) {
        return true;
      } else {
        return value == 1;
      }
    } catch (e) {
      rethrow;
    }
  }

  ///sets last review date converted to utc
  static Future<void> setLastReviewDate(DateTime date) async {
    try {
      final utcDate = date.toUtc().toIso8601String();
      await Hive.box(boxKey).put(lastInAppReviewKey, utcDate);
    } catch (e) {
      rethrow;
    }
  }

  ///gives datetime converted to local
  static DateTime? getLastReviewDate() {
    try {
      final String? reviewDate = Hive.box(boxKey).get(lastInAppReviewKey);

      if (reviewDate != null) {
        DateTime? value = DateTime.tryParse(reviewDate)?.asUtcToLocal;
        return value;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
