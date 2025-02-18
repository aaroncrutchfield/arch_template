import 'dart:async';

import 'package:analytics/src/analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// {@template firebase_analytics}
/// Firebase implementation of Analytics.
/// Handles tracking events, user properties, and errors using Firebase
/// Analytics.
/// {@endtemplate}
class FirebaseAnalyticsService implements Analytics {
  /// {@macro firebase_analytics}
  FirebaseAnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  void trackEvent(
    String name, {
    Map<String, Object>? parameters,
  }) {
    unawaited(
      _analytics.logEvent(
        name: name,
        parameters: parameters,
      ),
    );
  }

  @override
  Future<void> setUserProperties(Map<String, dynamic> properties) {
    return Future.wait(
      properties.entries.map(
        (entry) => _analytics.setUserProperty(
          name: entry.key,
          value: entry.value?.toString(),
        ),
      ),
    );
  }

  @override
  void identifyUser(String userId) {
    unawaited(_analytics.setUserId(id: userId));
  }

  @override
  Future<void> trackScreenView(
    String screenName, {
    Map<String, Object>? parameters,
  }) {
    return _analytics.logScreenView(
      screenName: screenName,
      parameters: parameters,
    );
  }

  @override
  Future<void> reset() {
    return _analytics.resetAnalyticsData();
  }
}
