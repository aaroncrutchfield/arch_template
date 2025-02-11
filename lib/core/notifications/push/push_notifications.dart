import 'package:firebase_messaging/firebase_messaging.dart';

/// Interface for push notification services
abstract interface class PushNotifications {
  /// Stream of messages received when the app is in the foreground
  Stream<RemoteMessage> get onForegroundMessage;

  /// Stream of messages received when the app is opened from terminated state
  Stream<RemoteMessage?> get onInitialMessage;

  /// Stream of messages that opened the app from the background
  Stream<RemoteMessage> get onBackgroundMessage;

  /// Requests notification permissions from the user
  /// Returns true if permission was granted
  Future<bool> requestPermissions();

  /// Gets the device token for push notifications
  /// Returns null if token could not be obtained
  Future<String?> getToken();

  /// Subscribe to a topic for receiving topic-based notifications
  Future<void> subscribeToTopic(String topic);

  /// Unsubscribe from a topic to stop receiving topic-based notifications
  Future<void> unsubscribeFromTopic(String topic);

  /// Delete the device token
  Future<void> deleteToken();
}
