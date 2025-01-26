import 'package:analytics/src/firebase_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// {@template analytics}
/// Interface for analytics implementations
/// {@endtemplate}
abstract class Analytics {
  
  // coverage:ignore-start
  /// Factory constructor for [Analytics]. Be sure to initialize Firebase
  /// before using this constructor.
  ///
  /// Returns an instance of [FirebaseAnalyticsService]
  factory Analytics() => FirebaseAnalyticsService(FirebaseAnalytics.instance);
  // coverage:ignore-end

  /// Tracks a named event with optional parameters
  Future<void> trackEvent(String name, {Map<String, Object>? parameters});

  /// Sets user properties
  Future<void> setUserProperties(Map<String, dynamic> properties);

  /// Identifies the current user
  Future<void> identifyUser(String userId);

  /// Starts tracking a screen view
  Future<void> trackScreenView(
    String screenName, {
    Map<String, Object>? parameters,
  });

  /// Resets all analytics data
  Future<void> reset();
}
