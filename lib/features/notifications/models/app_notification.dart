import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// {@template app_notification}
/// Model representing a notification in the app
/// {@endtemplate}
class AppNotification extends Equatable {
  /// {@macro app_notification}
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
  });

  /// {@macro app_notification_from_remote_message}
  factory AppNotification.fromRemoteMessage(RemoteMessage message) {
    return AppNotification(
      id: message.messageId ?? '',
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      payload: message.data,
    );
  }

  /// Unique identifier for the notification
  final String id;

  /// Title of the notification
  final String title;

  /// Body text of the notification
  final String body;

  /// Additional data payload
  final Map<String, dynamic>? payload;

  @override
  List<Object?> get props => [id, title, body, payload];
}
