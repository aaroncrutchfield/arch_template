# Analytics

A Flutter package that provides analytics functionality using Firebase Analytics, with support for event tracking, user properties, and screen tracking.

## Features

- Event tracking with parameters
- User property management
- Screen view tracking
- Custom parameter validation
- Platform-aware implementation
- Strongly typed analytics events

## Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  analytics:
    path: packages/analytics
```

## Getting Started

1. Initialize Firebase in your app before creating any Analytics instances:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

2. Create an instance of Analytics after Firebase is initialized:

```dart
final analytics = Analytics(FirebaseAnalytics.instance);
```

Note: Attempting to create an Analytics instance before Firebase is initialized will result in an error.

## Usage

### Track Events

```dart
try {
  await analytics.trackEvent(
    'button_clicked',
    parameters: {
      'button_id': 'login_button',
      'screen': 'login_page',
    },
  );
} on AnalyticsException catch (e) {
  print('Failed to track event: $e');
}
```

### Set User Properties

```dart
try {
  await analytics.setUserProperty(
    name: 'user_type',
    value: 'premium',
  );
} on AnalyticsException catch (e) {
  print('Failed to set user property: $e');
}
```

### Track Screen Views

```dart
try {
  await analytics.trackScreenView(
    screenName: 'HomeScreen',
    screenClass: 'HomePage',
  );
} on AnalyticsException catch (e) {
  print('Failed to track screen view: $e');
}
```

### Reset Analytics Data

```dart
try {
  await analytics.resetAnalyticsData();
  print('Analytics data reset successfully');
} on AnalyticsException catch (e) {
  print('Failed to reset analytics: $e');
}
```

## Error Handling

The package provides typed exceptions for different analytics failures:

- `AnalyticsException`
- `InvalidEventParameterException`
- `InvalidUserPropertyException`
- `AnalyticsDisabledException`

Each exception includes detailed error messages and stack traces for debugging.

## Testing

The package includes comprehensive tests demonstrating how to mock and verify analytics tracking:

```dart
// Example test
test('tracks event with parameters', () async {
  await analytics.trackEvent(
    'test_event',
    parameters: {'param': 'value'},
  );
  
  verify(() => firebaseAnalytics.logEvent(
    name: 'test_event',
    parameters: {'param': 'value'},
  )).called(1);
});
```

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## Additional Information

- Follows Very Good Ventures' package structure
- Uses mocktail for testing
- Implements consistent cross-platform analytics
- Provides type-safe event and parameter handling
- Supports offline event queueing
- Includes parameter validation
