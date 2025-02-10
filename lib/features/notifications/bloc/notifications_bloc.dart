import 'dart:async';

import 'package:arch_template/core/notifications/push/push_notifications.dart';
import 'package:arch_template/features/notifications/models/app_notification.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// {@template notifications_bloc}
/// Bloc that handles notification-related events and state
/// {@endtemplate}
@injectable
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  /// {@macro notifications_bloc}
  NotificationsBloc(this._pushNotifications)
      : super(const NotificationsState()) {
    on<NotificationsInitialized>(_onInitialized);
    on<NotificationReceived>(_onNotificationReceived);
    on<NotificationPermissionRequested>(_onPermissionRequested);

    add(const NotificationsInitialized());
  }

  final PushNotifications _pushNotifications;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _backgroundSubscription;
  StreamSubscription<RemoteMessage?>? _initialMessageSubscription;

  Future<void> _onInitialized(
    NotificationsInitialized event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _setupNotificationStreams();

      final hasPermission = await _pushNotifications.requestPermissions();
      if (hasPermission) {
        final token = await _pushNotifications.getToken();
        emit(
          state.copyWith(
            fcmToken: token,
            permissionStatus: NotificationPermissionStatus.granted,
          ),
        );
      } else {
        emit(
          state.copyWith(
            permissionStatus: NotificationPermissionStatus.denied,
          ),
        );
      }
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          permissionStatus: NotificationPermissionStatus.error,
          error: error,
        ),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> _onNotificationReceived(
    NotificationReceived event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      final notification = AppNotification(
        id: event.message.messageId ?? '',
        title: event.message.notification?.title ?? '',
        body: event.message.notification?.body ?? '',
        payload: event.message.data,
      );

      emit(
        state.copyWith(
          notifications: [...state.notifications, notification],
          lastNotification: notification,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(error: error));
      addError(error, stackTrace);
    }
  }

  Future<void> _onPermissionRequested(
    NotificationPermissionRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      final hasPermission = await _pushNotifications.requestPermissions();
      if (hasPermission) {
        final token = await _pushNotifications.getToken();
        emit(
          state.copyWith(
            fcmToken: token,
            permissionStatus: NotificationPermissionStatus.granted,
          ),
        );
      } else {
        emit(
          state.copyWith(
            permissionStatus: NotificationPermissionStatus.denied,
          ),
        );
      }
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          permissionStatus: NotificationPermissionStatus.error,
          error: error,
        ),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> _setupNotificationStreams() async {
    try {
      await _foregroundSubscription?.cancel();
      await _backgroundSubscription?.cancel();
      await _initialMessageSubscription?.cancel();

      _foregroundSubscription = _pushNotifications.onForegroundMessage.listen(
        (message) => add(NotificationReceived(message)),
        onError: addError,
      );

      _backgroundSubscription = _pushNotifications.onBackgroundMessage.listen(
        (message) => add(NotificationReceived(message)),
        onError: addError,
      );

      _initialMessageSubscription = _pushNotifications.onInitialMessage.listen(
        (message) {
          if (message != null) {
            add(NotificationReceived(message));
          }
        },
        onError: addError,
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    await _foregroundSubscription?.cancel();
    await _backgroundSubscription?.cancel();
    await _initialMessageSubscription?.cancel();
    return super.close();
  }
}
