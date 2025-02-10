import 'dart:async';
import 'dart:io';

import 'package:arch_template/core/notifications/push/push_notifications.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Firebase implementation of [PushNotifications]
@Injectable(as: PushNotifications)
class FirebasePushNotifications implements PushNotifications {
  /// {@macro firebase_push_notifications}
  FirebasePushNotifications(
    this._messaging,
    this._crashlytics,
  );

  final FirebaseMessaging _messaging;
  final FirebaseCrashlytics _crashlytics;

  void _reportError(Object error, StackTrace stackTrace) {
    unawaited(_crashlytics.recordError(error, stackTrace));
  }

  @override
  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage?> get onInitialMessage async* {
    try {
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        yield initialMessage;
      }
    } catch (e, stackTrace) {
      _reportError(e, stackTrace);
      debugPrint('Error getting initial message: $e');
    }
  }

  @override
  Stream<RemoteMessage> get onBackgroundMessage =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<bool> requestPermissions() async {
    try {
      final settings = await _messaging.requestPermission(
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
      if (Platform.isIOS) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          debugPrint('APNS token not available yet');
          return null;
        }
      }

      return await _messaging.getToken();
    } catch (e, stackTrace) {
      _reportError(e, stackTrace);
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (e, stackTrace) {
      _reportError(e, stackTrace);
      debugPrint('Error subscribing to topic: $e');
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
    } catch (e, stackTrace) {
      _reportError(e, stackTrace);
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
    } catch (e, stackTrace) {
      _reportError(e, stackTrace);
      debugPrint('Error deleting FCM token: $e');
    }
  }
}
