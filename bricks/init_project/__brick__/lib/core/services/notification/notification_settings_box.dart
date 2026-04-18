import 'package:hive_flutter/hive_flutter.dart';

class NotificationSettingsBox {
  static const String boxKey = 'notification_settings';

  static Future<void> open() async {
    await Hive.openBox(boxKey);
  }

  static Future<void> close() async {
    await Hive.box(boxKey).close();
  }

  static bool isOpen() => Hive.isBoxOpen(boxKey);

  static Future<void> saveSettings(NotificationSettings settings) async {
    try {
      await Hive.box(boxKey).put('jobNotifications', settings.jobNotifications);
      await Hive.box(boxKey)
          .put('bookingNotifications', settings.bookingNotifications);
      await Hive.box(boxKey)
          .put('paymentNotifications', settings.paymentNotifications);
      await Hive.box(boxKey)
          .put('messageNotifications', settings.messageNotifications);
      await Hive.box(boxKey)
          .put('reviewNotifications', settings.reviewNotifications);
      await Hive.box(boxKey)
          .put('generalNotifications', settings.generalNotifications);
    } catch (e) {
      rethrow;
    }
  }

  static NotificationSettings getSettings() {
    try {
      return NotificationSettings(
        jobNotifications:
            Hive.box(boxKey).get('jobNotifications', defaultValue: true),
        bookingNotifications:
            Hive.box(boxKey).get('bookingNotifications', defaultValue: true),
        paymentNotifications:
            Hive.box(boxKey).get('paymentNotifications', defaultValue: true),
        messageNotifications:
            Hive.box(boxKey).get('messageNotifications', defaultValue: true),
        reviewNotifications:
            Hive.box(boxKey).get('reviewNotifications', defaultValue: true),
        generalNotifications:
            Hive.box(boxKey).get('generalNotifications', defaultValue: true),
      );
    } catch (e) {
      return NotificationSettings.defaultSettings();
    }
  }
}

class NotificationSettings {
  final bool jobNotifications;
  final bool bookingNotifications;
  final bool paymentNotifications;
  final bool messageNotifications;
  final bool reviewNotifications;
  final bool generalNotifications;

  NotificationSettings({
    required this.jobNotifications,
    required this.bookingNotifications,
    required this.paymentNotifications,
    required this.messageNotifications,
    required this.reviewNotifications,
    required this.generalNotifications,
  });

  factory NotificationSettings.defaultSettings() {
    return NotificationSettings(
      jobNotifications: true,
      bookingNotifications: true,
      paymentNotifications: true,
      messageNotifications: true,
      reviewNotifications: true,
      generalNotifications: true,
    );
  }

  NotificationSettings copyWith({
    bool? jobNotifications,
    bool? bookingNotifications,
    bool? paymentNotifications,
    bool? messageNotifications,
    bool? reviewNotifications,
    bool? generalNotifications,
  }) {
    return NotificationSettings(
      jobNotifications: jobNotifications ?? this.jobNotifications,
      bookingNotifications: bookingNotifications ?? this.bookingNotifications,
      paymentNotifications: paymentNotifications ?? this.paymentNotifications,
      messageNotifications: messageNotifications ?? this.messageNotifications,
      reviewNotifications: reviewNotifications ?? this.reviewNotifications,
      generalNotifications: generalNotifications ?? this.generalNotifications,
    );
  }
}
