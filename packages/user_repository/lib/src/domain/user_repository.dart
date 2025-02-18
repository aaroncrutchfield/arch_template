import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/src/data/models/models.dart';
import 'package:user_repository/src/domain/firebase_user_repository.dart';

/// {@template user_repository}
/// Repository to manage user data.
/// {@endtemplate}
abstract interface class UserRepository {
  /// {@macro user_repository}
  factory UserRepository(FirebaseFirestore firestore) {
    return FirebaseUserRepository(firestore);
  }

  /// Get user by uid
  ///
  /// Throws [GetUserException] if the operation fails
  Future<UserEntity> getUser(String uid);

  /// Create a new user
  ///
  /// Throws [CreateUserException] if the operation fails
  Future<void> createUser(UserEntity user);

  /// Update user data
  ///
  /// Throws [UpdateUserException] if the operation fails
  Future<void> updateUser(UserEntity user);

  /// Stream of user data changes
  ///
  /// Throws [GetUserException] if the operation fails
  Stream<UserEntity?> userChanges(String email);
}
