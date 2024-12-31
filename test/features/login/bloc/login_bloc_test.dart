import 'package:arch_template/features/login/bloc/login_bloc.dart';
import 'package:arch_template/l10n/arb/app_localizations.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthUser extends Mock implements AuthUser {}

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  group('LoginBloc', () {
    late AuthRepository authRepository;
    late AuthUser authUser;
    late AppLocalizations l10n;

    setUp(() {
      authRepository = MockAuthRepository();
      authUser = MockAuthUser();
      l10n = MockAppLocalizations();

      when(() => l10n.signInWithGoogleFailed)
          .thenReturn('Google sign in failed');
      when(() => l10n.signInWithAppleFailed).thenReturn('Apple sign in failed');
    });

    test('initial state is LoginInitial', () {
      expect(
        LoginBloc(authRepository, l10n).state,
        equals(LoginInitial()),
      );
    });

    group('SignInWithGooglePressed', () {
      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoading, LoginSuccess] when sign in succeeds',
        setUp: () {
          when(() => authRepository.signInWithGoogle())
              .thenAnswer((_) async => authUser);
        },
        build: () => LoginBloc(authRepository, l10n),
        act: (bloc) => bloc.add(SignInWithGooglePressed()),
        expect: () => [
          LoginLoading(),
          LoginSuccess(),
        ],
        verify: (_) {
          verify(() => authRepository.signInWithGoogle()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoading, LoginFailure] when sign in fails',
        setUp: () {
          const error =
              SignInWithGoogleException('Sign in failed', StackTrace.empty);
          when(() => authRepository.signInWithGoogle()).thenThrow(error);
        },
        build: () => LoginBloc(authRepository, l10n),
        act: (bloc) => bloc.add(SignInWithGooglePressed()),
        expect: () => [
          LoginLoading(),
          const LoginFailure('Google sign in failed'),
        ],
        verify: (_) {
          verify(() => authRepository.signInWithGoogle()).called(1);
          verify(() => l10n.signInWithGoogleFailed).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'adds error to bloc when sign in fails',
        setUp: () {
          const error =
              SignInWithGoogleException('Sign in failed', StackTrace.empty);
          when(() => authRepository.signInWithGoogle()).thenThrow(error);
        },
        build: () => LoginBloc(authRepository, l10n),
        act: (bloc) => bloc.add(SignInWithGooglePressed()),
        errors: () => [isA<SignInWithGoogleException>()],
      );
    });

    group('SignInWithApplePressed', () {
      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoading, LoginSuccess] when sign in succeeds',
        setUp: () {
          when(() => authRepository.signInWithApple())
              .thenAnswer((_) async => authUser);
        },
        build: () => LoginBloc(authRepository, l10n),
        act: (bloc) => bloc.add(SignInWithApplePressed()),
        expect: () => [
          LoginLoading(),
          LoginSuccess(),
        ],
        verify: (_) {
          verify(() => authRepository.signInWithApple()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoading, LoginFailure] when sign in fails',
        setUp: () {
          const error =
              SignInWithAppleException('Sign in failed', StackTrace.empty);
          when(() => authRepository.signInWithApple()).thenThrow(error);
        },
        build: () => LoginBloc(authRepository, l10n),
        act: (bloc) => bloc.add(SignInWithApplePressed()),
        expect: () => [
          LoginLoading(),
          const LoginFailure('Apple sign in failed'),
        ],
        verify: (_) {
          verify(() => authRepository.signInWithApple()).called(1);
          verify(() => l10n.signInWithAppleFailed).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'adds error to bloc when sign in fails',
        setUp: () {
          const error =
              SignInWithAppleException('Sign in failed', StackTrace.empty);
          when(() => authRepository.signInWithApple()).thenThrow(error);
        },
        build: () => LoginBloc(authRepository, l10n),
        act: (bloc) => bloc.add(SignInWithApplePressed()),
        errors: () => [isA<SignInWithAppleException>()],
      );
    });
  });
}
