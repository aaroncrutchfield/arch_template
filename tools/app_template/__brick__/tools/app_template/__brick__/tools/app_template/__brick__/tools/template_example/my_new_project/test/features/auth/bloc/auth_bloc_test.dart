import 'package:/core/navigation/navigation.dart';
import 'package:/features/auth/bloc/auth_bloc.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAppNavigation extends Mock implements AppNavigation {}

class MockAuthUser extends Mock implements AuthUser {}

void main() {
  group('AuthBloc', () {
    late AuthRepository authRepository;
    late AppNavigation appNavigation;
    late AuthUser authUser;

    setUp(() {
      authRepository = MockAuthRepository();
      appNavigation = MockAppNavigation();
      authUser = MockAuthUser();

      // Setup default behavior for authStateChanges
      when(() => authRepository.authStateChanges())
          .thenAnswer((_) => Stream.value(null));
    });

    test('initial state is AuthInitial', () {
      expect(
        AuthBloc(authRepository, appNavigation).state,
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
        build: () => AuthBloc(authRepository, appNavigation),
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
        build: () => AuthBloc(authRepository, appNavigation),
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
        build: () => AuthBloc(authRepository, appNavigation),
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
          build: () => AuthBloc(authRepository, appNavigation),
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
          build: () => AuthBloc(authRepository, appNavigation),
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
  });
}
