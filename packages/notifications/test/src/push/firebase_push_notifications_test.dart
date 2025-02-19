import 'package:capabilites/capabilites.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications/src/push/firebase_messaging_wrapper.dart';
import 'package:notifications/src/push/firebase_push_notifications.dart';

class MockFirebaseMessagingWrapper extends Mock
    implements FirebaseMessagingWrapper {}

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

class MockRemoteMessage extends Mock implements RemoteMessage {}

class MockNotificationSettings extends Mock implements NotificationSettings {}

class MockCapabilities extends Mock implements Capabilites {}

void main() {
  late FirebasePushNotifications pushNotifications;
  late MockFirebaseMessagingWrapper messaging;
  late MockFirebaseCrashlytics crashlytics;
  late MockNotificationSettings settings;
  late MockCapabilities capability;
  setUp(() {
    messaging = MockFirebaseMessagingWrapper();
    crashlytics = MockFirebaseCrashlytics();
    settings = MockNotificationSettings();
    capability = MockCapabilities();
    pushNotifications =
        FirebasePushNotifications(messaging, crashlytics, capability);
  });

  group('FirebasePushNotifications', () {
    test('requestPermissions returns true when authorized', () async {
      when(() => settings.authorizationStatus)
          .thenReturn(AuthorizationStatus.authorized);
      when(() => messaging.requestPermission(provisional: true))
          .thenAnswer((_) async => settings);

      final result = await pushNotifications.requestPermissions();

      expect(result, isTrue);
    });

    test('requestPermissions returns true when provisional', () async {
      when(() => settings.authorizationStatus)
          .thenReturn(AuthorizationStatus.provisional);
      when(() => messaging.requestPermission(provisional: true))
          .thenAnswer((_) async => settings);

      final result = await pushNotifications.requestPermissions();

      expect(result, isTrue);
      verify(() => messaging.requestPermission(provisional: true)).called(1);
    });

    test('requestPermissions returns false when denied', () async {
      when(() => settings.authorizationStatus)
          .thenReturn(AuthorizationStatus.denied);
      when(() => messaging.requestPermission(provisional: true))
          .thenAnswer((_) async => settings);

      final result = await pushNotifications.requestPermissions();

      expect(result, isFalse);
      verify(() => messaging.requestPermission(provisional: true)).called(1);
    });

    group('getToken', () {
      test('returns FCM token when APNS not required', () async {
        when(capability.requireApnsToken).thenReturn(false);
        const token = 'test-token';
        when(() => messaging.getToken()).thenAnswer((_) async => token);

        final result = await pushNotifications.getToken();

        expect(result, equals(token));
        verify(() => messaging.getToken()).called(1);
        verifyNever(() => messaging.getAPNSToken());
      });

      group('when APNS required', () {
        setUp(() {
          when(capability.requireApnsToken).thenReturn(true);
          when(() => crashlytics.recordError(any<dynamic>(), any()))
              .thenAnswer((_) async => Future.value());
        });

        test('returns FCM token when APNS token available', () async {
          when(() => messaging.getAPNSToken())
              .thenAnswer((_) async => 'apns-token');
          when(() => messaging.getToken()).thenAnswer((_) async => 'fcm-token');

          final result = await pushNotifications.getToken();

          expect(result, equals('fcm-token'));
          verify(() => messaging.getAPNSToken()).called(1);
          verify(() => messaging.getToken()).called(1);
        });

        test('returns null when APNS token is null', () async {
          when(() => messaging.getAPNSToken()).thenAnswer((_) async => null);

          final result = await pushNotifications.getToken();

          expect(result, isNull);
          verify(() => messaging.getAPNSToken()).called(1);
          verifyNever(() => messaging.getToken());
        });

        test('handles error and returns null', () async {
          final error = Exception('Failed to get token');
          when(() => messaging.getAPNSToken()).thenThrow(error);

          final result = await pushNotifications.getToken();

          expect(result, isNull);
          verify(() => crashlytics.recordError(error, any())).called(1);
          verifyNever(() => messaging.getToken());
        });
      });
    });

    test('subscribeToTopic subscribes to topic', () async {
      const topic = 'test-topic';
      when(() => messaging.subscribeToTopic(topic)).thenAnswer((_) async => {});

      await pushNotifications.subscribeToTopic(topic);

      verify(() => messaging.subscribeToTopic(topic)).called(1);
    });

    test('unsubscribeFromTopic unsubscribes from topic', () async {
      const topic = 'test-topic';
      when(() => messaging.unsubscribeFromTopic(topic))
          .thenAnswer((_) async => {});

      await pushNotifications.unsubscribeFromTopic(topic);

      verify(() => messaging.unsubscribeFromTopic(topic)).called(1);
    });

    test('deleteToken deletes FCM token', () async {
      when(() => messaging.deleteToken()).thenAnswer((_) async => {});

      await pushNotifications.deleteToken();

      verify(() => messaging.deleteToken()).called(1);
    });

    group('message streams', () {
      test('onForegroundMessage returns FirebaseMessaging.onMessage', () {
        const stream = Stream<RemoteMessage>.empty();
        when(() => messaging.onMessage).thenAnswer((_) => stream);

        expect(pushNotifications.onForegroundMessage, equals(stream));
      });

      test('onBackgroundMessage returns FirebaseMessaging.onMessageOpenedApp',
          () {
        const stream = Stream<RemoteMessage>.empty();
        when(() => messaging.onMessageOpenedApp).thenAnswer((_) => stream);

        expect(pushNotifications.onBackgroundMessage, equals(stream));
      });

      test('onInitialMessage emits initial message when available', () async {
        final message = MockRemoteMessage();
        when(() => messaging.getInitialMessage())
            .thenAnswer((_) async => message);

        await expectLater(
          pushNotifications.onInitialMessage,
          emits(message),
        );
      });

      test('onInitialMessage handles null initial message', () async {
        when(() => messaging.getInitialMessage()).thenAnswer((_) async => null);

        await expectLater(
          pushNotifications.onInitialMessage,
          emits(null),
        );
      });
    });

    group('error handling', () {
      setUp(() {
        when(() => crashlytics.recordError(any<dynamic>(), any()))
            .thenAnswer((_) async => Future.value());
      });

      test('handles error in requestPermissions', () async {
        final error = Exception('test error');
        when(() => messaging.requestPermission(provisional: true))
            .thenThrow(error);

        final result = await pushNotifications.requestPermissions();

        expect(result, isFalse);
        verify(() => crashlytics.recordError(error, any())).called(1);
      });

      test('handles error in subscribeToTopic', () async {
        final error = Exception('test error');
        when(() => messaging.subscribeToTopic(any())).thenThrow(error);

        await pushNotifications.subscribeToTopic('topic');

        verify(() => crashlytics.recordError(error, any())).called(1);
      });

      test('handles error in unsubscribeFromTopic', () async {
        final error = Exception('test error');
        when(() => messaging.unsubscribeFromTopic(any())).thenThrow(error);

        await pushNotifications.unsubscribeFromTopic('topic');

        verify(() => crashlytics.recordError(error, any())).called(1);
      });

      test('handles error in deleteToken', () async {
        final error = Exception('test error');
        when(() => messaging.deleteToken()).thenThrow(error);

        await pushNotifications.deleteToken();

        verify(() => crashlytics.recordError(error, any())).called(1);
      });

      test('handles error in getInitialMessage', () async {
        final error = Exception('test error');
        when(() => messaging.getInitialMessage())
            .thenAnswer((_) async => Future.error(error));

        await expectLater(
          pushNotifications.onInitialMessage,
          emitsError(isA<Exception>()),
        );
        verify(() => crashlytics.recordError(error, any())).called(1);
      });
    });

    group('platform specific', () {
      setUp(() {
        when(capability.requireApnsToken).thenReturn(true);
      });

      test('getToken checks APNS token on iOS', () async {
        when(() => messaging.getAPNSToken())
            .thenAnswer((_) async => 'apns-token');
        when(() => messaging.getToken()).thenAnswer((_) async => 'fcm-token');

        final result = await pushNotifications.getToken();

        expect(result, equals('fcm-token'));
        verify(() => messaging.getAPNSToken()).called(1);
      });

      test('getToken returns null when APNS token is null on iOS', () async {
        when(() => messaging.getAPNSToken()).thenAnswer((_) async => null);

        final result = await pushNotifications.getToken();

        expect(result, isNull);
        verify(() => messaging.getAPNSToken()).called(1);
        verifyNever(() => messaging.getToken());
      });
    });
  });
}
