// coverage:ignore-file
// This file is not testable because it wraps static methods
import 'package:firebase_auth/firebase_auth.dart';

/// {@template google_auth_provider_client}
/// A client for Google authentication.
/// {@endtemplate}
class GoogleAuthProviderClient {
  /// {@macro google_auth_provider_client}
  const GoogleAuthProviderClient();

  /// Create a credential for Google authentication.
  ///
  /// {@macro create_credential}
  OAuthCredential createCredential({
    required String? accessToken,
    required String? idToken,
  }) {
    return GoogleAuthProvider.credential(
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
