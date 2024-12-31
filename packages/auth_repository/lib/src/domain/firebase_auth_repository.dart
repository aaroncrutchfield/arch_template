import 'package:auth_repository/src/data/models/models.dart';
import 'package:auth_repository/src/domain/auth_repository.dart';
import 'package:auth_repository/src/helpers/google_auth_provider_client.dart';
import 'package:auth_repository/src/helpers/platform_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// {@template firebase_auth_repository}
/// A repository for Firebase authentication.
/// {@endtemplate}
class FirebaseAuthRepository implements AuthRepository {
  /// {@macro firebase_auth_repository}
  const FirebaseAuthRepository(
    this._firebaseAuth,
    this._googleSignIn,
    this._appleAuthProvider,
    this._googleAuthProviderClient,
    this._platformHelper,
  );

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final AppleAuthProvider _appleAuthProvider;
  final GoogleAuthProviderClient _googleAuthProviderClient;
  final PlatformHelper _platformHelper;

  @override
  Stream<AuthUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(
          (user) => user != null ? AuthUser.fromFirebaseUser(user) : null,
        );
  }

  @override
  Future<AuthUser> signInWithApple() async {
    try {
      // Sign in with Apple.
      final userCredential = _platformHelper.isWeb == true
          ? await _firebaseAuth.signInWithPopup(_appleAuthProvider)
          : await _firebaseAuth.signInWithProvider(_appleAuthProvider);
      return AuthUser.fromFirebaseUser(userCredential.user!);
    } catch (e, s) {
      throw SignInWithAppleException(e, s);
    }
  }

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthUser.fromFirebaseUser(userCredential.user!);
    } catch (e, s) {
      throw SignInWithEmailException(e, s);
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      // Sign in with Google.
      final googleSignInAccount = await _googleSignIn.signIn();
      // Check if the user cancelled the sign in process.
      if (googleSignInAccount == null) {
        throw SignInWithGoogleException(
          'User cancelled the sign in process',
          StackTrace.current,
        );
      }
      // Get the authentication data from the Google sign-in account.
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      // Create a credential for Google authentication.
      final googleAuthCredential = _googleAuthProviderClient.createCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      // Sign in with the credential.
      final userCredential = await _firebaseAuth.signInWithCredential(
        googleAuthCredential,
      );
      return AuthUser.fromFirebaseUser(userCredential.user!);
    } catch (e, s) {
      throw SignInWithGoogleException(e, s);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e, s) {
      throw SignOutException(e, s);
    }
  }
}
