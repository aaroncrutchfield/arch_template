import 'package:auth_repository/src/data/models/auth_user.dart';
import 'package:auth_repository/src/data/models/exceptions.dart';
import 'package:auth_repository/src/domain/auth_repository.dart';
import 'package:auth_repository/src/domain/firebase_auth_repository.dart';
import 'package:auth_repository/src/helpers/google_auth_provider_client.dart';
import 'package:auth_repository/src/helpers/platform_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockAppleAuthProvider extends Mock implements AppleAuthProvider {}

class MockGoogleAuthProviderClient extends Mock
    implements GoogleAuthProviderClient {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockOAuthCredential extends Mock implements OAuthCredential {}

class MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  group('AuthRepository', () {
    late FirebaseAuth firebaseAuth;
    late GoogleSignIn googleSignIn;
    late AppleAuthProvider appleAuthProvider;
    late GoogleAuthProviderClient googleAuthProviderClient;
    late AuthRepository authRepository;
    late UserCredential userCredential;
    late User user;
    late PlatformHelper platformHelper;

    const testUser = AuthUser(
      id: 'test-id',
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: 'https://example.com/photo.jpg',
    );

    setUp(() {
      firebaseAuth = MockFirebaseAuth();
      googleSignIn = MockGoogleSignIn();
      appleAuthProvider = MockAppleAuthProvider();
      googleAuthProviderClient = MockGoogleAuthProviderClient();
      userCredential = MockUserCredential();
      user = MockUser();
      platformHelper = MockPlatformHelper();

      when(() => user.uid).thenReturn(testUser.id);
      when(() => user.email).thenReturn(testUser.email);
      when(() => user.displayName).thenReturn(testUser.name);
      when(() => user.photoURL).thenReturn(testUser.photoUrl);
      when(() => userCredential.user).thenReturn(user);

      authRepository = FirebaseAuthRepository(
        firebaseAuth,
        googleSignIn,
        appleAuthProvider,
        googleAuthProviderClient,
        platformHelper,
      );
    });

    test('default factory constructor creates FirebaseAuthRepository', () {
      // Arrange & Act
      final repository = AuthRepository(firebaseAuth);

      // Assert
      expect(repository, isA<FirebaseAuthRepository>());
    });

    group('authStateChanges', () {
      test('emits AuthUser when Firebase user is not null', () async {
        // Arrange
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('test-uid');
        when(() => firebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(mockUser));

        // Act
        final stream = authRepository.authStateChanges();

        // Assert
        expect(
          stream,
          emits(isA<AuthUser>().having((u) => u.id, 'id', 'test-uid')),
        );
      });

      test('emits null when Firebase user is null', () {
        // Arrange
        when(() => firebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(null));

        // Act
        final stream = authRepository.authStateChanges();

        // Assert
        expect(stream, emits(null));
      });
    });

    group('signInWithEmail', () {
      const email = 'test@example.com';
      const password = 'password123';

      test('signs in user successfully', () async {
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenAnswer((_) async => userCredential);

        final result = await authRepository.signInWithEmail(
          email: email,
          password: password,
        );

        expect(result, equals(testUser));
        verify(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('throws SignInWithEmailException on error', () async {
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenThrow(Exception('Sign in failed'));

        expect(
          () => authRepository.signInWithEmail(
            email: email,
            password: password,
          ),
          throwsA(isA<SignInWithEmailException>()),
        );
      });
    });

    group('signInWithGoogle', () {
      late GoogleSignInAccount googleSignInAccount;
      late GoogleSignInAuthentication googleSignInAuthentication;
      late OAuthCredential googleAuthCredential;

      setUp(() {
        googleSignInAccount = MockGoogleSignInAccount();
        googleSignInAuthentication = MockGoogleSignInAuthentication();
        googleAuthCredential = MockOAuthCredential();

        when(() => googleSignInAccount.authentication)
            .thenAnswer((_) async => googleSignInAuthentication);
        when(() => googleSignInAuthentication.idToken).thenReturn('id-token');
        when(() => googleSignInAuthentication.accessToken)
            .thenReturn('access-token');
      });

      test('signs in user successfully', () async {
        when(() => googleSignIn.signIn())
            .thenAnswer((_) async => googleSignInAccount);
        when(
          () => googleAuthProviderClient.createCredential(
            idToken: any(named: 'idToken'),
            accessToken: any(named: 'accessToken'),
          ),
        ).thenReturn(googleAuthCredential);
        when(() => firebaseAuth.signInWithCredential(googleAuthCredential))
            .thenAnswer((_) async => userCredential);

        final result = await authRepository.signInWithGoogle();

        expect(result, equals(testUser));
        verify(() => googleSignIn.signIn()).called(1);
        verify(() => firebaseAuth.signInWithCredential(googleAuthCredential))
            .called(1);
      });

      test('throws SignInWithGoogleException when user cancels', () async {
        when(() => googleSignIn.signIn()).thenAnswer((_) async => null);

        expect(
          authRepository.signInWithGoogle(),
          throwsA(isA<SignInWithGoogleException>()),
        );
      });

      test('throws SignInWithGoogleException on error', () async {
        when(() => googleSignIn.signIn())
            .thenThrow(Exception('Google sign in failed'));

        expect(
          authRepository.signInWithGoogle(),
          throwsA(isA<SignInWithGoogleException>()),
        );
      });
    });

    group('signInWithApple', () {
      test('signs in user successfully on mobile', () async {
        when(() => platformHelper.isWeb).thenReturn(false);
        when(() => firebaseAuth.signInWithProvider(appleAuthProvider))
            .thenAnswer((_) async => userCredential);

        final result = await authRepository.signInWithApple();

        expect(result, equals(testUser));
        verify(() => firebaseAuth.signInWithProvider(appleAuthProvider))
            .called(1);
        verify(() => platformHelper.isWeb).called(1);
        verifyNever(() => firebaseAuth.signInWithPopup(appleAuthProvider));
      });

      test('signs in user successfully on web', () async {
        when(() => platformHelper.isWeb).thenReturn(true);
        when(() => firebaseAuth.signInWithPopup(appleAuthProvider))
            .thenAnswer((_) async => userCredential);

        final result = await authRepository.signInWithApple();

        expect(result, equals(testUser));
        verify(() => firebaseAuth.signInWithPopup(appleAuthProvider)).called(1);
        verify(() => platformHelper.isWeb).called(1);
        verifyNever(() => firebaseAuth.signInWithProvider(appleAuthProvider));
      });

      test('throws SignInWithAppleException on mobile error', () async {
        when(() => platformHelper.isWeb).thenReturn(false);
        when(() => firebaseAuth.signInWithProvider(appleAuthProvider))
            .thenThrow(Exception('Apple sign in failed'));

        expect(
          authRepository.signInWithApple(),
          throwsA(isA<SignInWithAppleException>()),
        );
      });

      test('throws SignInWithAppleException on web error', () async {
        when(() => platformHelper.isWeb).thenReturn(true);
        when(() => firebaseAuth.signInWithPopup(appleAuthProvider))
            .thenThrow(Exception('Apple sign in failed'));

        expect(
          authRepository.signInWithApple(),
          throwsA(isA<SignInWithAppleException>()),
        );
      });
    });

    group('signOut', () {
      test('signs out user successfully', () async {
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

        await expectLater(
          authRepository.signOut(),
          completes,
        );
        verify(() => firebaseAuth.signOut()).called(1);
      });

      test('throws SignOutException on error', () async {
        when(() => firebaseAuth.signOut())
            .thenThrow(Exception('Sign out failed'));

        expect(
          authRepository.signOut(),
          throwsA(isA<SignOutException>()),
        );
      });
    });
  });
}
