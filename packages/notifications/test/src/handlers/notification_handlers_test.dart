import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications/src/handlers/notification_handlers.dart';
import 'package:notifications/src/local/flutter_local_notifications.dart';

class MockFlutterLocalNotificationsService extends Mock
    implements FlutterLocalNotificationsService {}

class MockRemoteMessage extends Mock implements RemoteMessage {}

class MockNotification extends Mock implements RemoteNotification {}

class MockAndroidNotification extends Mock implements AndroidNotification {}

class MockAppleNotification extends Mock implements AppleNotification {}

void main() {
  late NotificationHandlers handlers;
  late MockFlutterLocalNotificationsService localNotifications;

  setUp(() {
    localNotifications = MockFlutterLocalNotificationsService();
    handlers = NotificationHandlers(localNotifications);

    // Set up default data map for all tests
    registerFallbackValue(<String, dynamic>{});
  });

  group('NotificationHandlers', () {
    test('handles message with notification', () async {
      final notification = MockNotification();
      final message = MockRemoteMessage();

      when(() => message.notification).thenReturn(notification);
      when(() => message.data).thenReturn({}); // Add empty data map
      when(() => notification.title).thenReturn('Test Title');
      when(() => notification.body).thenReturn('Test Body');

      when(
        () => localNotifications.show(
          id: any(named: 'id'),
          title: 'Test Title',
          body: 'Test Body',
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) => Future.value());

      await handlers.handleRemoteMessage(message);

      verify(
        () => localNotifications.show(
          id: any(named: 'id'),
          title: 'Test Title',
          body: 'Test Body',
          payload: any(named: 'payload'),
        ),
      ).called(1);
    });

    test('handles message without notification', () async {
      final message = MockRemoteMessage();
      when(() => message.notification).thenReturn(null);
      when(() => message.data).thenReturn({}); // Add empty data map

      await handlers.handleRemoteMessage(message);

      verifyNever(
        () => localNotifications.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: any(named: 'payload'),
        ),
      );
    });

    test('handles message without notification or data', () async {
      final message = MockRemoteMessage();
      when(() => message.notification).thenReturn(null);
      when(() => message.data).thenReturn({}); // Add empty data map

      await handlers.handleRemoteMessage(message);

      verifyNever(
        () => localNotifications.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: any(named: 'payload'),
        ),
      );
    });

    test('handles error in showNotification', () async {
      final message = MockRemoteMessage();

      when(
        () => localNotifications.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: any(named: 'payload'),
        ),
      ).thenThrow(Exception('Failed to show notification'));

      // Should not throw
      await handlers.handleRemoteMessage(message);
    });

    test('handles message with Android notification', () async {
      final notification = MockNotification();
      final androidNotification = MockAndroidNotification();
      final message = MockRemoteMessage();

      when(() => message.notification).thenReturn(notification);
      when(() => message.data).thenReturn({});
      when(() => notification.title).thenReturn('Test Title');
      when(() => notification.body).thenReturn('Test Body');
      when(() => notification.android).thenReturn(androidNotification);
      when(() => notification.apple).thenReturn(null);

      when(
        () => localNotifications.show(
          id: any(named: 'id'),
          title: 'Test Title',
          body: 'Test Body',
          details: any(named: 'details'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) => Future.value());

      await handlers.handleRemoteMessage(message);

      verify(
        () => localNotifications.show(
          id: any(named: 'id'),
          title: 'Test Title',
          body: 'Test Body',
          details: any(named: 'details'),
          payload: any(named: 'payload'),
        ),
      ).called(1);
    });

    test('handles message with Apple notification', () async {
      final notification = MockNotification();
      final appleNotification = MockAppleNotification();
      final message = MockRemoteMessage();

      when(() => message.notification).thenReturn(notification);
      when(() => message.data).thenReturn({});
      when(() => notification.title).thenReturn('Test Title');
      when(() => notification.body).thenReturn('Test Body');
      when(() => notification.android).thenReturn(null);
      when(() => notification.apple).thenReturn(appleNotification);

      when(
        () => localNotifications.show(
          id: any(named: 'id'),
          title: 'Test Title',
          body: 'Test Body',
          details: any(named: 'details'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) => Future.value());

      await handlers.handleRemoteMessage(message);

      verify(
        () => localNotifications.show(
          id: any(named: 'id'),
          title: 'Test Title',
          body: 'Test Body',
          details: any(named: 'details'),
          payload: any(named: 'payload'),
        ),
      ).called(1);
    });

    test('handles message with both platform notifications', () async {
      final notification = MockNotification();
      final androidNotification = MockAndroidNotification();
      final appleNotification = MockAppleNotification();
      final message = MockRemoteMessage();

      when(() => message.notification).thenReturn(notification);
      when(() => message.data).thenReturn({});
      when(() => notification.title).thenReturn('Test Title');
      when(() => notification.body).thenReturn('Test Body');
      when(() => notification.android).thenReturn(androidNotification);
      when(() => notification.apple).thenReturn(appleNotification);

      when(
        () => localNotifications.show(
          id: any(named: 'id'),
          title: 'Test Title',
          body: 'Test Body',
          details: any(named: 'details'),
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) => Future.value());

      await handlers.handleRemoteMessage(message);

      verify(
        () => localNotifications.show(
          id: any(named: 'id'),
          title: 'Test Title',
          body: 'Test Body',
          details: any(named: 'details'),
          payload: any(named: 'payload'),
        ),
      ).called(1);
    });
  });
}
