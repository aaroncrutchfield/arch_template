import 'package:firebase_messaging/firebase_messaging.dart';

/// {@template firebase_messaging_client}
/// A wrapper around [FirebaseMessaging] to make it more testable
/// {@endtemplate}
class FirebaseMessagingWrapper {
  /// {@macro firebase_messaging_client}
  const FirebaseMessagingWrapper(this._messaging);

  final FirebaseMessaging _messaging;

  // coverage:ignore-start
  /// Stream of messages received when app is in foreground
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  /// Stream of messages received when app is in background
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;
  // coverage:ignore-end

  /// Gets the initial message that launched the app
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();

  /// Request notification permissions
  Future<NotificationSettings> requestPermission({
    bool provisional = false,
  }) =>
      _messaging.requestPermission(provisional: provisional);

  /// Get the FCM token
  Future<String?> getToken() => _messaging.getToken();

  /// Get the APNS token (iOS only)
  Future<String?> getAPNSToken() => _messaging.getAPNSToken();

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);

  /// Delete the FCM token
  Future<void> deleteToken() => _messaging.deleteToken();
}
