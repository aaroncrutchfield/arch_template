part of 'notifications_bloc.dart';

/// Status of notification permissions
enum NotificationPermissionStatus {
  /// Initial state
  initial,

  /// Permissions granted
  granted,

  /// Permissions denied
  denied,

  /// Error occurred while requesting permissions
  error,
}

/// {@template notifications_state}
/// State for the notifications bloc
/// {@endtemplate}
class NotificationsState extends Equatable {
  /// {@macro notifications_state}
  const NotificationsState({
    this.notifications = const [],
    this.lastNotification,
    this.fcmToken,
    this.permissionStatus = NotificationPermissionStatus.initial,
    this.error,
  });

  /// List of all notifications
  final List<AppNotification> notifications;

  /// Most recently received notification
  final AppNotification? lastNotification;

  /// FCM token for this device
  final String? fcmToken;

  /// Current permission status
  final NotificationPermissionStatus permissionStatus;

  /// Current error if any
  final Object? error;

  /// Creates a copy of this state with the given fields replaced
  NotificationsState copyWith({
    List<AppNotification>? notifications,
    AppNotification? lastNotification,
    String? fcmToken,
    NotificationPermissionStatus? permissionStatus,
    Object? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      lastNotification: lastNotification ?? this.lastNotification,
      fcmToken: fcmToken ?? this.fcmToken,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        lastNotification,
        fcmToken,
        permissionStatus,
        error,
      ];
}
