import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Interface for handling local notifications
abstract interface class LocalNotifications {
  /// Initialize the local notifications service
  Future<void> initialize();

  /// Show a notification
  Future<void> show({
    required int id,
    required String title,
    required String body,
    NotificationDetails? details,
    String? payload,
  });

  /// Cancel a specific notification
  Future<void> cancel(int id);

  /// Cancel all notifications
  Future<void> cancelAll();

  /// Dispose the local notifications service
  void dispose();
}
