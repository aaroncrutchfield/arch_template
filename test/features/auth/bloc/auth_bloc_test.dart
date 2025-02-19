import 'package:analytics/analytics.dart';
import 'package:arch_template/core/navigation/navigation.dart';
import 'package:arch_template/features/auth/bloc/auth_bloc.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAppNavigation extends Mock implements AppNavigation {}

class MockAuthUser extends Mock implements AuthUser {}

class MockAnalytics extends Mock implements Analytics {}

class MockUserEntity extends Mock implements UserEntity {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  group('AuthBloc', () {
    late AuthRepository authRepository;
    late UserRepository userRepository;
    late AppNavigation appNavigation;
    late AuthUser authUser;
    late Analytics mockAnalytics;
    late UserEntity mockUser;

    setUp(() {
      authRepository = MockAuthRepository();
      userRepository = MockUserRepository();
      appNavigation = MockAppNavigation();
      authUser = MockAuthUser();
      mockAnalytics = MockAnalytics();
      mockUser = MockUserEntity();

      // Setup default behavior for authUser
      when(() => authUser.id).thenReturn('test-user-id');

      // Setup default behavior for authStateChanges
      when(() => authRepository.authStateChanges())
          .thenAnswer((_) => Stream.value(null));

      // Setup default behavior for analytics methods
      when(() => mockAnalytics.identifyUser(any())).thenAnswer((_) async {});
      when(
        () => mockAnalytics.trackEvent(
          any(),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});

      when(() => mockUser.isOnboardComplete).thenReturn(true);
      when(() => userRepository.getUser(any()))
          .thenAnswer((_) async => mockUser);

      // Add setup for AuthUser methods used in toUserEntity
      when(() => authUser.email).thenReturn('test@example.com');
      when(() => authUser.name).thenReturn('Test User');
    });

    AuthBloc createBloc() => AuthBloc(
          authRepository,
          userRepository,
          appNavigation,
          mockAnalytics,
        );

    test('initial state is AuthInitial', () {
      expect(
        createBloc().state,
        equals(AuthInitial()),
      );
    });

    group('CheckAuthStateChanges', () {
      blocTest<AuthBloc, AuthState>(
        'navigates to home when user is authenticated and '
        'onboarding is complete',
        setUp: () {
          when(() => authRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(authUser));
          when(() => mockUser.isOnboardComplete).thenReturn(true);
          when(() => appNavigation.replaceNamed('/')).thenAnswer((_) async {});
        },
        build: createBloc,
        verify: (_) {
          verify(() => authRepository.authStateChanges()).called(1);
          verify(() => userRepository.getUser('test-user-id')).called(1);
          verify(() => appNavigation.replaceNamed('/')).called(1);
          verifyNever(() => appNavigation.replaceNamed('/onboarding'));
          verifyNever(() => appNavigation.replaceNamed('/login'));
        },
      );

      blocTest<AuthBloc, AuthState>(
        'navigates to onboarding when user is authenticated but onboarding '
        'is not complete',
        setUp: () {
          when(() => authRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(authUser));
          when(() => mockUser.isOnboardComplete).thenReturn(false);
          when(() => appNavigation.replaceNamed('/onboarding'))
              .thenAnswer((_) async {});
        },
        build: createBloc,
        verify: (_) {
          verify(() => authRepository.authStateChanges()).called(1);
          verify(() => userRepository.getUser('test-user-id')).called(1);
          verify(() => appNavigation.replaceNamed('/onboarding')).called(1);
          verifyNever(() => appNavigation.replaceNamed('/'));
          verifyNever(() => appNavigation.replaceNamed('/login'));
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits no states and navigates to login when user is not authenticated',
        setUp: () {
          when(() => authRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(null));
          when(() => appNavigation.replaceNamed('/login'))
              .thenAnswer((_) async {});
        },
        build: createBloc,
        verify: (_) {
          verify(() => authRepository.authStateChanges()).called(1);
          verify(() => appNavigation.replaceNamed('/login')).called(1);
          verifyNever(() => appNavigation.replaceNamed('/counter'));
        },
      );

      blocTest<AuthBloc, AuthState>(
        'handles multiple auth state changes',
        setUp: () {
          when(() => authRepository.authStateChanges()).thenAnswer(
            (_) => Stream.fromIterable([null, authUser, null]),
          );
          when(() => appNavigation.replaceNamed(any()))
              .thenAnswer((_) async {});
        },
        build: createBloc,
        verify: (_) {
          verify(() => authRepository.authStateChanges()).called(1);
          verify(() => appNavigation.replaceNamed('/login')).called(2);
          verify(() => appNavigation.replaceNamed('/')).called(1);
        },
      );

      group('error handling', () {
        final testError = Exception('Auth stream error');
        final userRepositoryError = Exception('User repository error');

        blocTest<AuthBloc, AuthState>(
          'emits AuthFailure and navigates to login on stream error',
          setUp: () {
            when(() => authRepository.authStateChanges()).thenAnswer(
              (_) => Stream.error(testError),
            );
            when(() => appNavigation.replaceNamed('/login'))
                .thenAnswer((_) async {});
          },
          build: createBloc,
          expect: () => [
            AuthFailure(testError.toString()),
          ],
          verify: (_) {
            verify(() => authRepository.authStateChanges()).called(1);
            verify(() => appNavigation.replaceNamed('/login')).called(1);
            verifyNever(() => appNavigation.replaceNamed('/counter'));
          },
          errors: () => [testError],
        );

        blocTest<AuthBloc, AuthState>(
          'emits AuthFailure and navigates to login on subscription error',
          setUp: () {
            when(() => authRepository.authStateChanges()).thenThrow(testError);
            when(() => appNavigation.replaceNamed('/login'))
                .thenAnswer((_) async {});
          },
          build: createBloc,
          expect: () => [
            AuthFailure(testError.toString()),
          ],
          verify: (_) {
            verify(() => authRepository.authStateChanges()).called(1);
            verify(() => appNavigation.replaceNamed('/login')).called(1);
            verifyNever(() => appNavigation.replaceNamed('/counter'));
          },
          errors: () => [testError],
        );

        blocTest<AuthBloc, AuthState>(
          'emits AuthFailure and navigates to login on user repository error',
          setUp: () {
            when(() => authRepository.authStateChanges())
                .thenAnswer((_) => Stream.value(authUser));
            when(() => userRepository.getUser(any()))
                .thenThrow(userRepositoryError);
            when(() => appNavigation.replaceNamed('/login'))
                .thenAnswer((_) async {});
          },
          build: createBloc,
          expect: () => [
            AuthFailure(userRepositoryError.toString()),
          ],
          errors: () => [userRepositoryError],
          verify: (_) {
            verify(() => authRepository.authStateChanges()).called(1);
            verify(() => userRepository.getUser('test-user-id')).called(1);
            verify(() => appNavigation.replaceNamed('/login')).called(1);
            verifyNever(() => appNavigation.replaceNamed('/'));
            verifyNever(() => appNavigation.replaceNamed('/onboarding'));
          },
        );
      });

      blocTest<AuthBloc, AuthState>(
        'creates new user when user does not exist',
        setUp: () {
          when(() => authRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(authUser));
          when(() => userRepository.getUser(any())).thenThrow(
            const GetUserException(
              'User not found',
              StackTrace.empty,
            ),
          );

          // Mock successful user creation
          when(() => userRepository.createUser(any())).thenAnswer((_) async {});

          // Mock navigation to onboarding
          when(() => appNavigation.replaceNamed('/onboarding'))
              .thenAnswer((_) async {});
        },
        build: createBloc,
        verify: (_) {
          verify(() => userRepository.getUser('test-user-id')).called(1);

          // Verify the user creation
          final userCaptor = verify(
            () => userRepository.createUser(captureAny()),
          ).captured.single as UserEntity;

          // Verify the user entity was created correctly from AuthUser
          expect(userCaptor.uid, equals('test-user-id'));
          expect(userCaptor.email, equals('test@example.com'));
          expect(userCaptor.username, equals('Test User'));
          expect(userCaptor.isOnboardComplete, isFalse);

          // Verify navigation to onboarding
          verify(() => appNavigation.replaceNamed('/onboarding')).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits failure when creating user fails',
        setUp: () {
          when(() => authRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(authUser));
          when(() => userRepository.getUser(any())).thenThrow(
            const GetUserException(
              'User not found',
              StackTrace.empty,
            ),
          );
          when(() => userRepository.createUser(any())).thenThrow(
            const CreateUserException(
              'Failed to create user',
              StackTrace.empty,
            ),
          );
          when(() => appNavigation.replaceNamed('/login'))
              .thenAnswer((_) async {});
        },
        build: createBloc,
        expect: () => [
          const AuthFailure('CreateUserException: Failed to create user'),
        ],
        verify: (_) {
          verify(() => appNavigation.replaceNamed('/login')).called(1);
        },
      );
    });

    group('analytics tracking', () {
      blocTest<AuthBloc, AuthState>(
        'tracks login and identifies user when auth state '
        'changes to authenticated',
        setUp: () {
          when(() => authUser.id).thenReturn('test-user-id');
          when(() => authRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(authUser));
          when(() => appNavigation.replaceNamed('/counter'))
              .thenAnswer((_) async {});
        },
        build: createBloc,
        verify: (_) {
          verify(() => mockAnalytics.identifyUser('test-user-id')).called(1);
          verify(() => mockAnalytics.trackEvent('login')).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'tracks logout when auth state changes to unauthenticated',
        setUp: () {
          when(() => authRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(null));
          when(() => appNavigation.replaceNamed('/login'))
              .thenAnswer((_) async {});
        },
        build: createBloc,
        verify: (_) {
          verify(() => mockAnalytics.trackEvent('logout')).called(1);
        },
      );
    });
  });
}
