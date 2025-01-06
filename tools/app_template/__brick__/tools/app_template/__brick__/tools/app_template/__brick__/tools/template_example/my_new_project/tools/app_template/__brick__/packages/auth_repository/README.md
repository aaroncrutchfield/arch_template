# Auth Repository

A Flutter package that provides authentication functionality using Firebase Auth, with support for email/password, Google, and Apple sign-in methods.

## Features

- Email/password authentication
- Google Sign-In
- Apple Sign-In
- Auth state management
- Platform-aware implementation
- Strongly typed exceptions

## Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  auth_repository:
    path: packages/auth_repository
```

## Getting Started

1. Initialize Firebase in your app
2. Create an instance of AuthRepository:

```dart
final authRepository = AuthRepository(FirebaseAuth.instance);
```

## Usage

### Listen to Auth State Changes

```dart
authRepository.authStateChanges().listen((user) {
  if (user != null) {
    // User is signed in
    print('Signed in: ${user.id}');
  } else {
    // User is signed out
    print('Signed out');
  }
});
```

### Sign In with Email/Password

```dart
try {
  final user = await authRepository.signInWithEmail(
    email: 'user@example.com',
    password: 'password123',
  );
  print('Signed in: ${user.id}');
} on SignInWithEmailException catch (e) {
  print('Sign in failed: $e');
}
```

### Sign In with Google

```dart
try {
  final user = await authRepository.signInWithGoogle();
  print('Signed in with Google: ${user.id}');
} on SignInWithGoogleException catch (e) {
  print('Google sign in failed: $e');
}
```

### Sign In with Apple

```dart
try {
  final user = await authRepository.signInWithApple();
  print('Signed in with Apple: ${user.id}');
} on SignInWithAppleException catch (e) {
  print('Apple sign in failed: $e');
}
```

### Sign Out

```dart
try {
  await authRepository.signOut();
  print('Signed out successfully');
} on SignOutException catch (e) {
  print('Sign out failed: $e');
}
```

## Error Handling

The package provides typed exceptions for different authentication failures:

- `SignInWithEmailException`
- `SignInWithGoogleException`
- `SignInWithAppleException`
- `SignOutException`

Each exception includes the original error and stack trace for debugging.

## Testing

Reference the test file for examples of mocking and testing the repository:

```dart:packages/auth_repository/test/src/domain/auth_repository_test.dart
startLine: 1
endLine: 289
```

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ❌ Linux (Firebase not configured)

## Additional Information

- Follows Very Good Ventures' package structure
- Uses mocktail for testing
- Implements platform-specific authentication flows
- Provides strongly-typed user model
