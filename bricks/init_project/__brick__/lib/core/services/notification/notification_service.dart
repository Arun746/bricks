import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wrench_and_bolts/core/enums/enums.dart';
import 'package:wrench_and_bolts/core/services/storage/hive/app_box/app_box.dart';
import 'package:wrench_and_bolts/core/services/notification/notification_settings_box.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Function(RemoteMessage)? onMessageReceived;
  Function(NotificationResponse)? onNotificationTapped;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _initializeLocalNotifications();
      await _requestPermission();
      await _setupForegroundMessageHandler();
      await _setupBackgroundMessageHandler();
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService initialization failed: $e');
      }
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _handleNotificationTapped,
    );

    await _createNotificationChannels();
  }

  @pragma('vm:entry-point')
  static void _handleIOSLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    if (kDebugMode) {
      print('iOS Local Notification: $title - $body');
    }
  }

  Future<void> _createNotificationChannels() async {
    try {
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        const jobChannel = AndroidNotificationChannel(
          'job_notifications',
          'Job Notifications',
          description: 'Notifications for job updates and status changes',
          importance: Importance.high,
          playSound: true,
        );

        const bookingChannel = AndroidNotificationChannel(
          'booking_notifications',
          'Booking Notifications',
          description: 'Notifications for booking and scheduling updates',
          importance: Importance.high,
          playSound: true,
        );

        const paymentChannel = AndroidNotificationChannel(
          'payment_notifications',
          'Payment Notifications',
          description: 'Notifications for payment updates',
          importance: Importance.high,
          playSound: true,
        );

        const messageChannel = AndroidNotificationChannel(
          'message_notifications',
          'Messages',
          description: 'Notifications for new messages',
          importance: Importance.defaultImportance,
          playSound: true,
        );

        const generalChannel = AndroidNotificationChannel(
          'general_notifications',
          'General Notifications',
          description: 'General app notifications',
          importance: Importance.defaultImportance,
          playSound: true,
        );

        await androidPlugin.createNotificationChannel(jobChannel);
        await androidPlugin.createNotificationChannel(bookingChannel);
        await androidPlugin.createNotificationChannel(paymentChannel);
        await androidPlugin.createNotificationChannel(messageChannel);
        await androidPlugin.createNotificationChannel(generalChannel);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating notification channels: $e');
      }
    }
  }

  Future<void> _requestPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        print(
            'Notification permission status: ${settings.authorizationStatus}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting notification permission: $e');
      }
    }
  }

  Future<void> _setupForegroundMessageHandler() async {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<void> _setupBackgroundMessageHandler() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    try {
      await NotificationService()._showLocalNotification(message);
    } catch (e) {
      if (kDebugMode) {
        print('Background message handler error: $e');
      }
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final data = message.data;
    final type = _getNotificationTypeFromData(data);

    if (!_shouldShowNotification(type)) return;

    _showLocalNotificationFromData(
      title: notification.title ?? '',
      body: notification.body ?? '',
      data: data,
      type: type,
    );

    onMessageReceived?.call(message);
  }

  void _handleNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;

    try {
      jsonDecode(payload);
      onNotificationTapped?.call(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final data = message.data;
    final type = _getNotificationTypeFromData(data);

    if (!_shouldShowNotification(type)) return;

    await _showLocalNotificationFromData(
      title: notification.title ?? '',
      body: notification.body ?? '',
      data: data,
      type: type,
    );
  }

  Future<void> _showLocalNotificationFromData({
    required String title,
    required String body,
    required Map<String, dynamic> data,
    required NotificationType type,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _getChannelId(type),
      _getChannelName(type),
      channelDescription: _getChannelDescription(type),
      importance: _getChannelImportance(type),
      priority: Priority.high,
      showWhen: true,
      autoCancel: true,
      enableLights: true,
      color: const Color(0xFF2196F3),
      ledColor: const Color(0xFF2196F3),
      ledOnMs: 1000,
      ledOffMs: 500,
      playSound: true,
      icon: '@mipmap/launcher_icon',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _localNotifications.show(
      id,
      title,
      body,
      details,
      payload: jsonEncode(data),
    );
  }

  bool _shouldShowNotification(NotificationType type) {
    final settings = NotificationSettingsBox.getSettings();
    switch (type) {
      case NotificationType.registration:
      case NotificationType.service:
        return settings.generalNotifications;
    }
  }

  NotificationType _getNotificationTypeFromData(Map<String, dynamic> data) {
    final typeString = data['type']?.toString().toLowerCase() ?? '';

    for (final type in NotificationType.values) {
      if (type.name.toLowerCase() == typeString) {
        return type;
      }
    }

    return NotificationType.service;
  }

  String _getChannelId(NotificationType type) {
    switch (type) {
      case NotificationType.registration:
      case NotificationType.service:
        return 'general_notifications';
    }
  }

  String _getChannelName(NotificationType type) {
    switch (type) {
      case NotificationType.registration:
      case NotificationType.service:
        return 'General Notifications';
    }
  }

  String _getChannelDescription(NotificationType type) {
    switch (type) {
      case NotificationType.registration:
      case NotificationType.service:
        return 'General app notifications';
    }
  }

  Importance _getChannelImportance(NotificationType type) {
    switch (type) {
      case NotificationType.registration:
      case NotificationType.service:
        return Importance.defaultImportance;
    }
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Stream<String> get onTokenRefresh {
    return _firebaseMessaging.onTokenRefresh;
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> saveTokenToStorage() async {
    final token = await getToken();
    if (token != null) {
      await AppBox.setFCMToken(token);
    }
  }

  String? getStoredToken() {
    return AppBox.getFCMToken();
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }
}
