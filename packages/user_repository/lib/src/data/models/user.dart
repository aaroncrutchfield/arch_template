import 'package:equatable/equatable.dart';

/// {@template user_entity}
/// A user entity representing application user data.
/// {@endtemplate}
class UserEntity extends Equatable {
  /// {@macro user_entity}
  const UserEntity({
    required this.uid,
    required this.username,
    required this.email,
    required this.isOnboardComplete,
  });

  /// The unique identifier of the user
  final String uid;

  /// The username of the user
  final String username;

  /// The email of the user
  final String email;

  /// Whether the user has completed onboarding
  final bool isOnboardComplete;

  /// Creates a copy of this user with the given fields replaced
  UserEntity copyWith({
    String? uid,
    String? username,
    String? email,
    bool? isOnboardComplete,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      isOnboardComplete: isOnboardComplete ?? this.isOnboardComplete,
    );
  }

  @override
  List<Object?> get props => [uid, username, email, isOnboardComplete];

  @override
  String toString() {
    return 'UserEntity(uid: $uid, username: $username, email: $email, '
        'isOnboardComplete: $isOnboardComplete)';
  }
}
