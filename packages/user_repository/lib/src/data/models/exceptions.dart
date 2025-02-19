/// {@template user_exception}
/// Base exception class for user repository errors.
/// {@endtemplate}
abstract class UserException implements Exception {
  /// {@macro user_exception}
  const UserException(this.error, this.stackTrace);

  /// The error that occurred
  final Object error;

  /// The stack trace of the error
  final StackTrace stackTrace;

  @override
  String toString() => '$runtimeType: $error\n$stackTrace';
}

/// {@template get_user_exception}
/// Exception thrown when getting user fails.
/// {@endtemplate}
class GetUserException extends UserException {
  /// {@macro get_user_exception}
  const GetUserException(super.error, super.stackTrace);
}

/// {@template update_user_exception}
/// Exception thrown when updating user fails.
/// {@endtemplate}
class UpdateUserException extends UserException {
  /// {@macro update_user_exception}
  const UpdateUserException(super.error, super.stackTrace);
}

/// {@template create_user_exception}
/// Exception thrown when creating user fails.
/// {@endtemplate}
class CreateUserException extends UserException {
  /// {@macro create_user_exception}
  const CreateUserException(super.error, super.stackTrace);
}
