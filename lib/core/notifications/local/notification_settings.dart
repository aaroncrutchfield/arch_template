import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Platform-specific notification settings
class NotificationSettings {
  /// iOS initialization settings
  static const DarwinInitializationSettings ios =
      DarwinInitializationSettings();

  /// Android initialization settings
  static const AndroidInitializationSettings android =
      AndroidInitializationSettings(
    'launch_background', // TODO(acrutchfield): Add proper icon
  );

  /// Combined initialization settings
  static const InitializationSettings initializationSettings =
      InitializationSettings(
    android: android,
    iOS: ios,
  );
}
