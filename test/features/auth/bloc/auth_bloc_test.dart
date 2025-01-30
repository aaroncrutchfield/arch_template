import 'package:analytics/analytics.dart';
import 'package:arch_template/core/navigation/navigation.dart';
import 'package:arch_template/features/auth/bloc/auth_bloc.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAppNavigation extends Mock implements AppNavigation {}

class MockAuthUser extends Mock implements AuthUser {}

class MockAnalytics extends Mock implements Analytics {}

void main() {
  group('AuthBloc', () {
    late AuthRepository authRepository;
    late AppNavigation appNavigation;
    late AuthUser authUser;
    late Analytics mockAnalytics;

    setUp(() {
      authRepository = MockAuthRepository();
      appNavigation = MockAppNavigation();
      authUser = MockAuthUser();
      mockAnalytics = MockAnalytics();

      // Setup default behavior for authUser
      when(() => authUser.id).thenReturn('test-user-id');

      // Setup default behavior for authStateChanges
      when(() => authRepository.authStateChanges())
          .thenAnswer((_) => Stream.value(null));

      // Setup default behavior for analytics methods
      when(() => mockAnalytics.identifyUser(any())).thenAnswer((_) async {});
      when(() => mockAnalytics.trackEvent(
            any(),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async {});
    });

    AuthBloc createBloc() => AuthBloc(
          authRepository,
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
        'emits no states and navigates to counter when user is authenticated',
        setUp: () {
          when(() => authRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(authUser));
          when(() => appNavigation.replaceNamed('/counter'))
              .thenAnswer((_) async {});
        },
        build: createBloc,
        verify: (_) {
          verify(() => authRepository.authStateChanges()).called(1);
          verify(() => appNavigation.replaceNamed('/counter')).called(1);
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
          verify(() => appNavigation.replaceNamed('/counter')).called(1);
        },
      );

      group('error handling', () {
        final testError = Exception('Auth stream error');

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
      });
    });

    group('analytics tracking', () {
      blocTest<AuthBloc, AuthState>(
        'tracks login and identifies user when auth state changes to authenticated',
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
