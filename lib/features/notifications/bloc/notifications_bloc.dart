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
    on<NotificationPermissionRequested>(_onPermissionRequested);

    on<_SubscribeToInitialMessages>(_onSubscribeToInitialMessages);
    on<_SubscribeToForegroundMessages>(_onSubscribeToForegroundMessages);
    on<_SubscribeToBackgroundMessages>(_onSubscribeToBackgroundMessages);

    add(const NotificationsInitialized());
  }

  final PushNotifications _pushNotifications;

  Future<void> _onInitialized(
    NotificationsInitialized event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      add(const _SubscribeToInitialMessages());
      add(const _SubscribeToForegroundMessages());
      add(const _SubscribeToBackgroundMessages());

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

  Future<void> _onSubscribeToInitialMessages(
    _SubscribeToInitialMessages event,
    Emitter<NotificationsState> emit,
  ) async {
    await emit.forEach<RemoteMessage?>(
      _pushNotifications.onInitialMessage,
      onData: (message) {
        if (message != null) {
          final notification = AppNotification.fromRemoteMessage(message);
          return state.copyWith(
            notifications: state.notifications + [notification],
            lastNotification: notification,
          );
        } else {
          return state;
        }
      },
      onError: _onMessageError,
    );
  }

  Future<void> _onSubscribeToForegroundMessages(
    _SubscribeToForegroundMessages event,
    Emitter<NotificationsState> emit,
  ) async {
    await emit.forEach<RemoteMessage>(
      _pushNotifications.onForegroundMessage,
      onData: _onNewMessage,
      onError: _onMessageError,
    );
  }

  NotificationsState _onMessageError(Object error, StackTrace stackTrace) {
    addError(error, stackTrace);
    return state.copyWith(error: error);
  }

  NotificationsState _onNewMessage(RemoteMessage message) {
    final notification = AppNotification.fromRemoteMessage(message);
    return state.copyWith(
      notifications: state.notifications + [notification],
    );
  }

  Future<void> _onSubscribeToBackgroundMessages(
    _SubscribeToBackgroundMessages event,
    Emitter<NotificationsState> emit,
  ) async {
    await emit.forEach<RemoteMessage>(
      _pushNotifications.onBackgroundMessage,
      onData: _onNewMessage,
      onError: _onMessageError,
    );
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
}
