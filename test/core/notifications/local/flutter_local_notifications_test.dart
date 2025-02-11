import 'dart:async';

import 'package:arch_template/core/notifications/local/flutter_local_notifications.dart';
import 'package:arch_template/core/notifications/local/notification_channels.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockInitializationSettings extends Mock
    implements InitializationSettings {}

class MockNotificationDetails extends Mock implements NotificationDetails {}

class MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

class MockNotificationResponse extends Mock implements NotificationResponse {}

void main() {
  late FlutterLocalNotificationsService service;
  late MockFlutterLocalNotificationsPlugin plugin;
  late MockAndroidFlutterLocalNotificationsPlugin androidPlugin;

  setUp(() {
    plugin = MockFlutterLocalNotificationsPlugin();
    androidPlugin = MockAndroidFlutterLocalNotificationsPlugin();
    service = FlutterLocalNotificationsService(plugin);

    registerFallbackValue(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    registerFallbackValue(const NotificationDetails());
    registerFallbackValue(NotificationChannels.highImportance);
  });

  group('FlutterLocalNotificationsService', () {
    test('initialize configures plugin', () async {
      when(
        () => plugin.initialize(
          any(),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        ),
      ).thenAnswer((_) async => true);

      await service.initialize();

      verify(
        () => plugin.initialize(
          any(),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        ),
      ).called(1);
    });

    test('initialize handles failure', () async {
      when(
        () => plugin.initialize(
          any(),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        ),
      ).thenAnswer((_) async => false);

      await service.initialize();
    });

    test('initialize handles errors', () async {
      when(
        () => plugin.initialize(
          any(),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        ),
      ).thenAnswer((_) => Future.error(Exception('Failed')));

      // Should not throw
      await expectLater(
        service.initialize(),
        completes,
      );
    });

    test('initialize creates Android notification channel', () async {
      when(
        () => plugin.initialize(
          any(),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        ),
      ).thenAnswer((_) async => true);

      when(
        () => plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>(),
      ).thenReturn(androidPlugin);

      when(() => androidPlugin.createNotificationChannel(any()))
          .thenAnswer((_) async => true);

      await service.initialize();

      verify(
        () => androidPlugin.createNotificationChannel(
          NotificationChannels.highImportance,
        ),
      ).called(1);
    });

    group('show', () {
      setUp(() {
        when(
          () => plugin.show(
            any(),
            any(),
            any(),
            any(),
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((_) => Future<void>.value());
      });

      test('shows notification with default details', () async {
        await service.show(
          id: 1,
          title: 'Test Title',
          body: 'Test Body',
        );

        verify(
          () => plugin.show(
            1,
            'Test Title',
            'Test Body',
            NotificationChannels.defaultPlatformChannels,
          ),
        ).called(1);
      });

      test('shows notification with custom details', () async {
        final details = MockNotificationDetails();

        await service.show(
          id: 1,
          title: 'Test Title',
          body: 'Test Body',
          details: details,
          payload: 'test-payload',
        );

        verify(
          () => plugin.show(
            1,
            'Test Title',
            'Test Body',
            details,
            payload: 'test-payload',
          ),
        ).called(1);
      });

      test('handles errors', () async {
        when(
          () => plugin.show(
            any(),
            any(),
            any(),
            any(),
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((_) => Future<void>.error(Exception('Failed')));

        // Should not throw
        await expectLater(
          service.show(
            id: 1,
            title: 'Test Title',
            body: 'Test Body',
          ),
          completes,
        );
      });
    });

    test('cancel cancels notification', () async {
      when(() => plugin.cancel(any())).thenAnswer((_) => Future<void>.value());

      await service.cancel(1);

      verify(() => plugin.cancel(1)).called(1);
    });

    test('cancelAll cancels all notifications', () async {
      when(() => plugin.cancelAll()).thenAnswer((_) => Future<void>.value());

      await service.cancelAll();

      verify(() => plugin.cancelAll()).called(1);
    });
  });

  group('notification taps', () {
    test('emits response when notification is tapped', () async {
      final response = MockNotificationResponse();
      when(() => response.payload).thenReturn('test-payload');

      // Get the onDidReceiveNotificationResponse callback
      late void Function(NotificationResponse) callback;
      when(
        () => plugin.initialize(
          any(),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        ),
      ).thenAnswer((invocation) {
        callback = invocation.namedArguments[#onDidReceiveNotificationResponse]
            as void Function(NotificationResponse);
        return Future.value(true);
      });

      await service.initialize();

      // Listen to tap events
      unawaited(
        expectLater(
          service.onNotificationTapped,
          emits(response),
        ),
      );

      // Simulate notification tap
      callback(response);
    });

    test('handles notification response with null payload', () async {
      final response = MockNotificationResponse();
      when(() => response.payload).thenReturn(null);

      late void Function(NotificationResponse) callback;
      when(
        () => plugin.initialize(
          any(),
          onDidReceiveNotificationResponse:
              any(named: 'onDidReceiveNotificationResponse'),
        ),
      ).thenAnswer((invocation) {
        callback = invocation.namedArguments[#onDidReceiveNotificationResponse]
            as void Function(NotificationResponse);
        return Future.value(true);
      });

      await service.initialize();

      unawaited(
        expectLater(
          service.onNotificationTapped,
          emits(response),
        ),
      );

      callback(response);
    });
  });

  tearDown(() {
    service.dispose();
  });
}
