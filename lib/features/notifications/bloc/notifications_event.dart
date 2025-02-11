part of 'notifications_bloc.dart';

/// Base class for notification events
abstract class NotificationsEvent {
  const NotificationsEvent();
}

/// Event to initialize notifications
class NotificationsInitialized extends NotificationsEvent {
  const NotificationsInitialized();
}

/// Event to request notification permissions
class NotificationPermissionRequested extends NotificationsEvent {
  const NotificationPermissionRequested();
}

/// Event to handle subscription to initial messages
class _SubscribeToInitialMessages extends NotificationsEvent {
  const _SubscribeToInitialMessages();
}

/// Event to handle subscription to foreground messages
class _SubscribeToForegroundMessages extends NotificationsEvent {
  const _SubscribeToForegroundMessages();
}

/// Event to handle subscription to background messages
class _SubscribeToBackgroundMessages extends NotificationsEvent {
  const _SubscribeToBackgroundMessages();
}
