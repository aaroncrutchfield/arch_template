import 'package:arch_template/core/notifications/push/firebase_messaging_wrapper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockNotificationSettings extends Mock implements NotificationSettings {}

void main() {
  late FirebaseMessagingWrapper wrapper;
  late MockFirebaseMessaging messaging;

  setUp(() {
    messaging = MockFirebaseMessaging();
    wrapper = FirebaseMessagingWrapper(messaging);
  });

  group('FirebaseMessagingWrapper', () {
    test('getInitialMessage delegates to messaging', () async {
      const message = RemoteMessage();
      when(() => messaging.getInitialMessage())
          .thenAnswer((_) async => message);

      final result = await wrapper.getInitialMessage();

      expect(result, equals(message));
      verify(() => messaging.getInitialMessage()).called(1);
    });

    test('requestPermission delegates to messaging', () async {
      final settings = MockNotificationSettings();
      when(() => messaging.requestPermission(provisional: true))
          .thenAnswer((_) async => settings);

      final result = await wrapper.requestPermission(provisional: true);

      expect(result, equals(settings));
      verify(() => messaging.requestPermission(provisional: true)).called(1);
    });

    group('getToken', () {
      test('returns token when successful', () async {
        const token = 'test-token';
        when(() => messaging.getToken()).thenAnswer((_) async => token);

        final result = await wrapper.getToken();

        expect(result, equals(token));
        verify(() => messaging.getToken()).called(1);
      });

      test('returns null when token is null', () async {
        when(() => messaging.getToken()).thenAnswer((_) async => null);

        final result = await wrapper.getToken();

        expect(result, isNull);
        verify(() => messaging.getToken()).called(1);
      });

      test('propagates errors', () async {
        final error = Exception('Failed to get token');
        when(() => messaging.getToken()).thenThrow(error);

        expect(
          () => wrapper.getToken(),
          throwsA(equals(error)),
        );
      });
    });

    test('getAPNSToken delegates to messaging', () async {
      const token = 'apns-token';
      when(() => messaging.getAPNSToken()).thenAnswer((_) async => token);

      final result = await wrapper.getAPNSToken();

      expect(result, equals(token));
      verify(() => messaging.getAPNSToken()).called(1);
    });

    test('subscribeToTopic delegates to messaging', () async {
      const topic = 'test-topic';
      when(() => messaging.subscribeToTopic(topic)).thenAnswer((_) async => {});

      await wrapper.subscribeToTopic(topic);

      verify(() => messaging.subscribeToTopic(topic)).called(1);
    });

    test('unsubscribeFromTopic delegates to messaging', () async {
      const topic = 'test-topic';
      when(() => messaging.unsubscribeFromTopic(topic))
          .thenAnswer((_) async => {});

      await wrapper.unsubscribeFromTopic(topic);

      verify(() => messaging.unsubscribeFromTopic(topic)).called(1);
    });

    test('deleteToken delegates to messaging', () async {
      when(() => messaging.deleteToken()).thenAnswer((_) async => {});

      await wrapper.deleteToken();

      verify(() => messaging.deleteToken()).called(1);
    });

    // Note: Static streams are ignored in coverage
    group('streams', () {
      test('onMessage is accessible', () {
        expect(wrapper.onMessage, isA<Stream<RemoteMessage>>());
      });

      test('onMessageOpenedApp is accessible', () {
        expect(wrapper.onMessageOpenedApp, isA<Stream<RemoteMessage>>());
      });
    });
  });
}
