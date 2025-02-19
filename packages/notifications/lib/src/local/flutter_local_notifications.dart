import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifications/src/local/local_notifications.dart';
import 'package:notifications/src/local/notification_channels.dart';

/// Flutter implementation of [LocalNotifications]
class FlutterLocalNotificationsService implements LocalNotifications {
  /// {@macro flutter_local_notifications_service}
  FlutterLocalNotificationsService(this._localNotifications);

  final FlutterLocalNotificationsPlugin _localNotifications;
  final _notificationTapController =
      StreamController<NotificationResponse>.broadcast();

  /// Stream of notification tap events with their payloads
  Stream<NotificationResponse> get onNotificationTapped =>
      _notificationTapController.stream;

  @override
  Future<void> initialize() async {
    try {
      await _localNotifications.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('app_icon'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create the Android notification channel
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(NotificationChannels.highImportance);
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    NotificationDetails? details,
    String? payload,
  }) async {
    try {
      await _localNotifications.show(
        id,
        title,
        body,
        details ?? NotificationChannels.defaultPlatformChannels,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  @override
  Future<void> cancel(int id) => _localNotifications.cancel(id);

  @override
  Future<void> cancelAll() => _localNotifications.cancelAll();

  void _onNotificationTapped(NotificationResponse response) {
    _notificationTapController.add(response);
  }

  @override
  void dispose() {
    _notificationTapController.close();
  }
}
