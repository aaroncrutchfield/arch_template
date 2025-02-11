import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Default notification channels configuration
class NotificationChannels {
  /// High importance channel for Android
  static const AndroidNotificationChannel highImportance =
      AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  /// Default notification details
  static final NotificationDetails defaultPlatformChannels =
      NotificationDetails(
    android: AndroidNotificationDetails(
      highImportance.id,
      highImportance.name,
      channelDescription: highImportance.description,
      importance: highImportance.importance,
    ),
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    ),
  );
}
