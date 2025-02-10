import 'package:arch_template/core/notifications/local/local_notifications.dart';
import 'package:arch_template/core/notifications/local/notification_channels.dart';
import 'package:arch_template/core/notifications/local/notification_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

/// Flutter implementation of [LocalNotifications]
@Injectable(as: LocalNotifications)
class FlutterLocalNotificationsService implements LocalNotifications {
  /// {@macro flutter_local_notifications_service}
  FlutterLocalNotificationsService(this._localNotifications);

  final FlutterLocalNotificationsPlugin _localNotifications;

  @override
  Future<void> initialize() async {
    await _localNotifications.initialize(
      NotificationSettings.initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create the Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(NotificationChannels.highImportance);
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    NotificationDetails? details,
    String? payload,
  }) async {
    await _localNotifications.show(
      id,
      title,
      body,
      details ?? NotificationChannels.defaultPlatformChannels,
      payload: payload,
    );
  }

  @override
  Future<void> cancel(int id) => _localNotifications.cancel(id);

  @override
  Future<void> cancelAll() => _localNotifications.cancelAll();

  void _onNotificationTapped(NotificationResponse response) {
    // TODO(acrutchfield): Implement notification tap handling
    debugPrint('Notification tapped: ${response.payload}');
  }
}
