import 'package:arch_template/features/notifications/bloc/notifications_bloc.dart';
import 'package:arch_template/features/notifications/models/app_notification.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications/src/push/push_notifications.dart';

class MockPushNotifications extends Mock implements PushNotifications {}

class MockRemoteMessage extends Mock implements RemoteMessage {}

class MockNotification extends Mock implements RemoteNotification {}

void main() {
  late NotificationsBloc bloc;
  late MockPushNotifications mockPushNotifications;
  late MockRemoteMessage mockMessage;
  late MockNotification mockNotification;

  setUp(() {
    mockPushNotifications = MockPushNotifications();
    mockMessage = MockRemoteMessage();
    mockNotification = MockNotification();

    // Setup default message mocks
    when(() => mockMessage.messageId).thenReturn('test-id');
    when(() => mockMessage.notification).thenReturn(mockNotification);
    when(() => mockNotification.title).thenReturn('Test Title');
    when(() => mockNotification.body).thenReturn('Test Body');
    when(() => mockMessage.data).thenReturn({'key': 'value'});

    // Setup default stream responses
    when(() => mockPushNotifications.onForegroundMessage)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPushNotifications.onBackgroundMessage)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockPushNotifications.onInitialMessage)
        .thenAnswer((_) => const Stream.empty());
  });

  group('NotificationsBloc', () {
    test('initial state is correct', () {
      bloc = NotificationsBloc(mockPushNotifications);
      expect(
        bloc.state,
        equals(const NotificationsState()),
      );
    });

    group('NotificationsInitialized', () {
      blocTest<NotificationsBloc, NotificationsState>(
        'emits granted status and FCM token when permissions are granted',
        setUp: () {
          when(() => mockPushNotifications.requestPermissions())
              .thenAnswer((_) async => true);
          when(() => mockPushNotifications.getToken())
              .thenAnswer((_) async => 'test-token');
        },
        build: () => NotificationsBloc(mockPushNotifications),
        expect: () => [
          const NotificationsState(
            fcmToken: 'test-token',
            permissionStatus: NotificationPermissionStatus.granted,
          ),
        ],
      );

      blocTest<NotificationsBloc, NotificationsState>(
        'emits denied status when permissions are denied',
        setUp: () {
          when(() => mockPushNotifications.requestPermissions())
              .thenAnswer((_) async => false);
        },
        build: () => NotificationsBloc(mockPushNotifications),
        expect: () => [
          const NotificationsState(
            permissionStatus: NotificationPermissionStatus.denied,
          ),
        ],
      );

      blocTest<NotificationsBloc, NotificationsState>(
        'emits error status when initialization fails',
        setUp: () {
          when(() => mockPushNotifications.requestPermissions())
              .thenThrow(Exception('Test error'));
        },
        build: () => NotificationsBloc(mockPushNotifications),
        expect: () => [
          predicate<NotificationsState>(
            (state) =>
                state.permissionStatus == NotificationPermissionStatus.error &&
                state.error is Exception,
          ),
        ],
      );
    });

    group('Message Subscriptions', () {
      blocTest<NotificationsBloc, NotificationsState>(
        'handles foreground messages',
        setUp: () {
          when(() => mockPushNotifications.onForegroundMessage).thenAnswer(
            (_) => Stream.value(mockMessage),
          );
          when(() => mockPushNotifications.requestPermissions())
              .thenAnswer((_) async => true);
          when(() => mockPushNotifications.getToken())
              .thenAnswer((_) async => 'test-token');
        },
        build: () => NotificationsBloc(mockPushNotifications),
        expect: () => [
          const NotificationsState(
            fcmToken: 'test-token',
            permissionStatus: NotificationPermissionStatus.granted,
          ),
          const NotificationsState(
            notifications: [
              AppNotification(
                id: 'test-id',
                title: 'Test Title',
                body: 'Test Body',
                payload: {'key': 'value'},
              ),
            ],
            lastNotification: AppNotification(
              id: 'test-id',
              title: 'Test Title',
              body: 'Test Body',
              payload: {'key': 'value'},
            ),
            fcmToken: 'test-token',
            permissionStatus: NotificationPermissionStatus.granted,
          ),
        ],
      );

      blocTest<NotificationsBloc, NotificationsState>(
        'handles background messages',
        setUp: () {
          when(() => mockPushNotifications.onBackgroundMessage).thenAnswer(
            (_) => Stream.value(mockMessage),
          );
          when(() => mockPushNotifications.requestPermissions())
              .thenAnswer((_) async => true);
          when(() => mockPushNotifications.getToken())
              .thenAnswer((_) async => 'test-token');
        },
        build: () => NotificationsBloc(mockPushNotifications),
        expect: () => [
          const NotificationsState(
            fcmToken: 'test-token',
            permissionStatus: NotificationPermissionStatus.granted,
          ),
          predicate<NotificationsState>((state) {
            final notification = state.notifications.first;
            return state.notifications.length == 1 &&
                notification.id == 'test-id' &&
                notification.title == 'Test Title' &&
                notification.body == 'Test Body' &&
                notification.payload?['key'] == 'value' &&
                state.lastNotification == notification;
          }),
        ],
      );

      blocTest<NotificationsBloc, NotificationsState>(
        'handles initial message',
        setUp: () {
          when(() => mockPushNotifications.onInitialMessage).thenAnswer(
            (_) => Stream.value(mockMessage),
          );
          when(() => mockPushNotifications.requestPermissions())
              .thenAnswer((_) async => true);
          when(() => mockPushNotifications.getToken())
              .thenAnswer((_) async => 'test-token');
        },
        build: () => NotificationsBloc(mockPushNotifications),
        expect: () => [
          const NotificationsState(
            fcmToken: 'test-token',
            permissionStatus: NotificationPermissionStatus.granted,
          ),
          predicate<NotificationsState>((state) {
            final notification = state.notifications.first;
            return state.notifications.length == 1 &&
                notification.id == 'test-id' &&
                notification.title == 'Test Title' &&
                notification.body == 'Test Body' &&
                notification.payload?['key'] == 'value' &&
                state.lastNotification == notification;
          }),
        ],
      );

      blocTest<NotificationsBloc, NotificationsState>(
        'handles null initial message',
        setUp: () {
          when(() => mockPushNotifications.onInitialMessage).thenAnswer(
            (_) => Stream.value(null),
          );
          when(() => mockPushNotifications.requestPermissions())
              .thenAnswer((_) async => true);
          when(() => mockPushNotifications.getToken())
              .thenAnswer((_) async => 'test-token');
        },
        build: () => NotificationsBloc(mockPushNotifications),
        expect: () => [
          const NotificationsState(
            fcmToken: 'test-token',
            permissionStatus: NotificationPermissionStatus.granted,
          ),
        ],
      );

      blocTest<NotificationsBloc, NotificationsState>(
        'handles stream errors',
        setUp: () {
          when(() => mockPushNotifications.onForegroundMessage).thenAnswer(
            (_) => Stream.error(Exception('Stream error')),
          );
          when(() => mockPushNotifications.requestPermissions())
              .thenAnswer((_) async => true);
          when(() => mockPushNotifications.getToken())
              .thenAnswer((_) async => 'test-token');
        },
        build: () => NotificationsBloc(mockPushNotifications),
        expect: () => [
          const NotificationsState(
            fcmToken: 'test-token',
            permissionStatus: NotificationPermissionStatus.granted,
          ),
          predicate<NotificationsState>(
            (state) => state.error is Exception,
          ),
        ],
      );
    });

    group('NotificationPermissionRequested', () {
      blocTest<NotificationsBloc, NotificationsState>(
        'emits granted status and token when permissions are granted',
        setUp: () {
          when(() => mockPushNotifications.requestPermissions())
              .thenAnswer((_) async => true);
          when(() => mockPushNotifications.getToken())
              .thenAnswer((_) async => 'test-token');
        },
        build: () => NotificationsBloc(mockPushNotifications),
        act: (bloc) => bloc.add(const NotificationPermissionRequested()),
        expect: () => [
          const NotificationsState(
            fcmToken: 'test-token',
            permissionStatus: NotificationPermissionStatus.granted,
          ),
        ],
      );

      blocTest<NotificationsBloc, NotificationsState>(
        'emits denied status when permissions are denied',
        setUp: () {
          when(() => mockPushNotifications.requestPermissions())
              .thenAnswer((_) async => false);
        },
        build: () => NotificationsBloc(mockPushNotifications),
        act: (bloc) => bloc.add(const NotificationPermissionRequested()),
        expect: () => [
          const NotificationsState(
            permissionStatus: NotificationPermissionStatus.denied,
          ),
        ],
      );

      blocTest<NotificationsBloc, NotificationsState>(
        'emits error status when permission request fails',
        setUp: () {
          when(() => mockPushNotifications.requestPermissions())
              .thenThrow(Exception('Permission error'));
        },
        build: () => NotificationsBloc(mockPushNotifications),
        act: (bloc) => bloc.add(const NotificationPermissionRequested()),
        expect: () => [
          predicate<NotificationsState>(
            (state) =>
                state.permissionStatus == NotificationPermissionStatus.error &&
                state.error is Exception,
          ),
        ],
      );
    });
  });
}
