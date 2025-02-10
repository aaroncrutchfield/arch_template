part of 'notifications_bloc.dart';

/// {@template notifications_event}
/// Base class for all notification events
/// {@endtemplate}
abstract class NotificationsEvent extends Equatable {
  /// {@macro notifications_event}
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// Event emitted when notifications are initialized
class NotificationsInitialized extends NotificationsEvent {
  /// {@macro notifications_initialized}
  const NotificationsInitialized();
}

/// Event emitted when a notification is received
class NotificationReceived extends NotificationsEvent {
  /// {@macro notification_received}
  const NotificationReceived(this.message);

  /// The received message
  final RemoteMessage message;

  @override
  List<Object?> get props => [message];
}

/// Event emitted when notification permissions are requested
class NotificationPermissionRequested extends NotificationsEvent {
  /// {@macro notification_permission_requested}
  const NotificationPermissionRequested();
}
