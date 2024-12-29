import 'package:auth_repository/src/data/models/auth_user.dart';
import 'package:auth_repository/src/data/models/exceptions.dart';
import 'package:auth_repository/src/domain/firebase_auth_repository.dart';
import 'package:auth_repository/src/helpers/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// {@template auth_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract interface class AuthRepository {
  /// {@macro auth_repository}
  factory AuthRepository(FirebaseAuth firebaseAuth) {
    return FirebaseAuthRepository(
      firebaseAuth,
      GoogleSignIn(),
      AppleAuthProvider(),
      const GoogleAuthProviderClient(),
      PlatformHelper(),
    );
  }

  /// The current user.
  AuthUser? get currentUser;

  /// Sign in with email.
  ///
  /// Throws [SignInWithEmailException] if the sign in fails.
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google.
  ///
  /// Throws [SignInWithGoogleException] if the sign in fails.
  Future<AuthUser> signInWithGoogle();

  /// Sign in with Apple.
  ///
  /// Throws [SignInWithAppleException] if the sign in fails.
  Future<AuthUser> signInWithApple();

  /// Sign out.
  ///
  /// Throws [SignOutException] if the sign out fails.
  Future<void> signOut();
}
