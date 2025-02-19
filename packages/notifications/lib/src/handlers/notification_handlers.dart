import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifications/src/local/local_notifications.dart';
import 'package:notifications/src/local/notification_channels.dart';

/// Handles notification-related events
class NotificationHandlers {
  /// {@macro notification_handlers}
  const NotificationHandlers(this._localNotifications);

  final LocalNotifications _localNotifications;

  /// Handle a remote message by showing a local notification
  Future<void> handleRemoteMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final android = notification.android;
    final apple = notification.apple;

    final details = android != null || apple != null
        ? NotificationDetails(
            android: android != null
                ? NotificationChannels.defaultPlatformChannels.android
                : null,
            iOS: apple != null
                ? NotificationChannels.defaultPlatformChannels.iOS
                : null,
          )
        : null;

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title ?? '',
      body: notification.body ?? '',
      details: details,
      payload: message.data.toString(),
    );
  }
}
