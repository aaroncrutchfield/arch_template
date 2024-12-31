import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// {@template auth_user}
/// A user for authentication.
/// {@endtemplate}
class AuthUser extends Equatable {
  /// {@macro auth_user}
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.photoUrl,
  });

  /// Create an [AuthUser] from a [User].
  AuthUser.fromFirebaseUser(User user)
    : id = user.uid,
      email = user.email ?? '',
      name = user.displayName ?? '',
      photoUrl = user.photoURL ?? '';

  /// The ID of the user.
  final String id;

  /// The email of the user.
  final String email;

  /// The name of the user.
  final String name;

  /// The photo URL of the user.
  final String photoUrl;

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, name: $name, photoUrl: $photoUrl)';
  }

  @override
  List<Object?> get props => [id, email, name, photoUrl];
}
