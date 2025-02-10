import 'package:equatable/equatable.dart';

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
