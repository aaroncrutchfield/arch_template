import 'dart:async';

import 'package:arch_template/core/notifications/push/firebase_messaging_wrapper.dart';
import 'package:arch_template/core/notifications/push/push_notifications.dart';
import 'package:arch_template/core/platform/capability.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Firebase implementation of [PushNotifications]
@Injectable(as: PushNotifications)
class FirebasePushNotifications implements PushNotifications {
  /// {@macro firebase_push_notifications}
  FirebasePushNotifications(
    this._messagingClient,
    this._crashlytics,
    this._capability,
  );

  final FirebaseMessagingWrapper _messagingClient;
  final FirebaseCrashlytics _crashlytics;
  final Capability _capability;
  void _reportError(Object error, StackTrace stackTrace) {
    unawaited(_crashlytics.recordError(error, stackTrace));
  }

  @override
  Stream<RemoteMessage> get onForegroundMessage => _messagingClient.onMessage;

  @override
  Stream<RemoteMessage?> get onInitialMessage async* {
    try {
      yield await _messagingClient.getInitialMessage();
    } catch (e, stackTrace) {
      _reportError(e, stackTrace);
      debugPrint('Error getting initial message: $e');
      rethrow;
    }
  }

  @override
  Stream<RemoteMessage> get onBackgroundMessage =>
      _messagingClient.onMessageOpenedApp;

  @override
  Future<bool> requestPermissions() async {
    try {
      final settings = await _messagingClient.requestPermission(
        provisional: true, // Allow provisional permissions on iOS
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e, stackTrace) {
      _reportError(e, stackTrace);
      debugPrint('Error requesting notification permissions: $e');
      return false;
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      // For apple platforms, ensure the APNS token is available
      if (_capability.requireApnsToken()) {
        final apnsToken = await _messagingClient.getAPNSToken();
        if (apnsToken == null) {
          debugPrint('APNS token not available yet');
          return null;
        }
      }

      return await _messagingClient.getToken();
    } catch (e, stackTrace) {
      _reportError(e, stackTrace);
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messagingClient.subscribeToTopic(topic);
    } catch (e, stackTrace) {
      _reportError(e, stackTrace);
      debugPrint('Error subscribing to topic: $e');
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messagingClient.unsubscribeFromTopic(topic);
    } catch (e, stackTrace) {
      _reportError(e, stackTrace);
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _messagingClient.deleteToken();
    } catch (e, stackTrace) {
      _reportError(e, stackTrace);
      debugPrint('Error deleting FCM token: $e');
    }
  }
}
