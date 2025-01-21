/// {@template auth_exception}
/// An exception that occurs during authentication.
/// {@endtemplate}
abstract class AuthException implements Exception {
  /// {@macro auth_exception}
  const AuthException(this.error, this.stackTrace);

  /// The error that occurred.
  final Object error;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  @override
  String toString() => '$runtimeType: $error\n stackTrace: $stackTrace';
}

/// {@template sign_in_with_email_exception}
/// An exception that occurs when signing in with email.
/// {@endtemplate}
class SignInWithEmailException extends AuthException {
  /// {@macro sign_in_with_email_exception}
  const SignInWithEmailException(super.error, super.stackTrace);
}

/// {@template sign_in_with_google_exception}
/// An exception that occurs when signing in with Google.
/// {@endtemplate}
class SignInWithGoogleException extends AuthException {
  /// {@macro sign_in_with_google_exception}
  const SignInWithGoogleException(super.error, super.stackTrace);
}

/// {@template sign_in_with_apple_exception}
/// An exception that occurs when signing in with Apple.
/// {@endtemplate}
class SignInWithAppleException extends AuthException {
  /// {@macro sign_in_with_apple_exception}
  const SignInWithAppleException(super.error, super.stackTrace);
}

/// {@template sign_out_exception}
/// An exception that occurs when signing out.
/// {@endtemplate}
class SignOutException extends AuthException {
  /// {@macro sign_out_exception}
  const SignOutException(super.error, super.stackTrace);
}
