import 'package:analytics/analytics.dart';
import 'package:analytics/src/firebase_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  group('FirebaseAnalyticsService', () {
    late FirebaseAnalytics mockAnalytics;
    late FirebaseAnalyticsService service;

    setUp(() {
      mockAnalytics = MockFirebaseAnalytics();
      service = FirebaseAnalyticsService(mockAnalytics);
    });

    test('trackEvent logs event with parameters', () async {
      const name = 'test_event';
      final parameters = {'key': 'value'};

      when(
        () => mockAnalytics.logEvent(
          name: name,
          parameters: parameters,
        ),
      ).thenAnswer((_) async {});

      await service.trackEvent(name, parameters: parameters);

      verify(
        () => mockAnalytics.logEvent(
          name: name,
          parameters: parameters,
        ),
      ).called(1);
    });

    test('setUserProperties sets all properties', () async {
      final properties = {'prop1': 'value1', 'prop2': 'value2'};

      when(
        () => mockAnalytics.setUserProperty(
          name: any(named: 'name'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await service.setUserProperties(properties);

      verify(
        () => mockAnalytics.setUserProperty(
          name: 'prop1',
          value: 'value1',
        ),
      ).called(1);
      verify(
        () => mockAnalytics.setUserProperty(
          name: 'prop2',
          value: 'value2',
        ),
      ).called(1);
    });

    test('identifyUser sets user ID', () async {
      const userId = 'test_user_123';

      when(
        () => mockAnalytics.setUserId(id: userId),
      ).thenAnswer((_) async {});

      await service.identifyUser(userId);

      verify(
        () => mockAnalytics.setUserId(id: userId),
      ).called(1);
    });

    test('trackScreenView logs screen view with parameters', () async {
      const screenName = 'test_screen';
      final parameters = {'key': 'value'};

      when(
        () => mockAnalytics.logScreenView(
          screenName: screenName,
          parameters: parameters,
        ),
      ).thenAnswer((_) async {});

      await service.trackScreenView(screenName, parameters: parameters);

      verify(
        () => mockAnalytics.logScreenView(
          screenName: screenName,
          parameters: parameters,
        ),
      ).called(1);
    });

    test('reset clears analytics data', () async {
      when(
        () => mockAnalytics.resetAnalyticsData(),
      ).thenAnswer((_) async {});

      await service.reset();

      verify(
        () => mockAnalytics.resetAnalyticsData(),
      ).called(1);
    });
  });
}
