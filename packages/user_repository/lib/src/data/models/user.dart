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
    this.isDarkMode = false,
  });

  /// The unique identifier of the user
  final String uid;

  /// The username of the user
  final String username;

  /// The email of the user
  final String email;

  /// Whether the user has completed onboarding
  final bool isOnboardComplete;

  /// Whether the user prefers dark mode
  final bool isDarkMode;

  /// Creates a copy of this user with the given fields replaced
  UserEntity copyWith({
    String? uid,
    String? username,
    String? email,
    bool? isOnboardComplete,
    bool? isDarkMode,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      isOnboardComplete: isOnboardComplete ?? this.isOnboardComplete,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props =>
      [uid, username, email, isOnboardComplete, isDarkMode];

  @override
  String toString() {
    return 'UserEntity(uid: $uid, username: $username, email: $email, '
        'isOnboardComplete: $isOnboardComplete, isDarkMode: $isDarkMode)';
  }
}
