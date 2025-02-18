import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/src/data/models/models.dart';
import 'package:user_repository/src/domain/user_repository.dart';

/// Extensions for Firebase conversions
extension UserEntityFirebaseX on UserEntity {
  /// Converts this [UserEntity] to a Map for Firestore storage
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'isOnboardComplete': isOnboardComplete,
    };
  }
}

/// Static Firebase conversion methods
extension UserEntityFirebaseConverter on UserEntity {
  /// Creates a [UserEntity] from a Firestore document snapshot
  static UserEntity fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return UserEntity(
      uid: snapshot.id,
      username: data['username'] as String,
      email: data['email'] as String,
      isOnboardComplete: data['isOnboardComplete'] as bool,
    );
  }

  /// Converts a [UserEntity] to a Map for Firestore storage
  static Map<String, dynamic> toFirestore(
    UserEntity entity,
    SetOptions? options,
  ) {
    return entity.toFirestore();
  }
}

/// {@template firebase_user_repository}
/// Firebase implementation of [UserRepository].
/// {@endtemplate}
class FirebaseUserRepository implements UserRepository {
  /// {@macro firebase_user_repository}
  const FirebaseUserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  /// Collection reference for users
  CollectionReference<UserEntity> get _usersCollection =>
      _firestore.collection('users').withConverter<UserEntity>(
            fromFirestore: UserEntityFirebaseConverter.fromFirestore,
            toFirestore: UserEntityFirebaseConverter.toFirestore,
          );

  @override
  Future<UserEntity> getUser(String email) async {
    try {
      final snapshot = await _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw GetUserException('User not found', StackTrace.current);
      }

      return snapshot.docs.first.data();
    } catch (e, s) {
      throw GetUserException(e, s);
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    try {
      final docRef = _usersCollection.doc(user.uid);
      await docRef.set(user);
    } catch (e, s) {
      throw UpdateUserException(e, s);
    }
  }

  @override
  Stream<UserEntity?> userChanges(String email) {
    try {
      return _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty) return null;
        return snapshot.docs.first.data();
      });
    } catch (e, s) {
      throw GetUserException(e, s);
    }
  }

  @override
  Future<void> createUser(UserEntity user) async {
    try {
      await _usersCollection.doc(user.uid).set(user);
    } catch (e, s) {
      throw CreateUserException(e, s);
    }
  }
}
