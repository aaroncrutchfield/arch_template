import 'package:arch_template/core/notifications/local/local_notifications.dart';
import 'package:arch_template/core/notifications/local/notification_channels.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

/// Handles notification-related events
@injectable
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
