import 'package:arch_template/features/login/bloc/login_bloc.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthUser extends Mock implements AuthUser {}

void main() {
  late AuthRepository authRepository;
  late AuthUser mockUser;

  setUp(() {
    authRepository = MockAuthRepository();
    mockUser = MockAuthUser();

    // Register fallback values for mocktail
    registerFallbackValue(LoginInitial());
    registerFallbackValue(SignInWithGooglePressed());
    registerFallbackValue(SignInWithApplePressed());
  });

  LoginBloc buildBloc() => LoginBloc(authRepository);

  group('LoginBloc', () {
    group('constructor', () {
      test('works properly', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(buildBloc().state, equals(LoginInitial()));
      });
    });

    group('error handling', () {
      blocTest<LoginBloc, LoginState>(
        'handles errors properly',
        build: buildBloc,
        act: (bloc) => bloc.add(SignInWithGooglePressed()),
        setUp: () {
          when(() => authRepository.signInWithGoogle())
              .thenThrow(Exception('test error'));
        },
        errors: () => [isA<Exception>()],
      );
    });

    group('SignInWithGooglePressed', () {
      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoading, LoginSuccess] when successful',
        setUp: () {
          when(() => authRepository.signInWithGoogle())
              .thenAnswer((_) async => mockUser);
        },
        build: buildBloc,
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
        'emits [LoginLoading, GoogleLoginFailure] when '
        'SignInWithGoogleException occurs',
        setUp: () {
          when(() => authRepository.signInWithGoogle()).thenThrow(
            SignInWithGoogleException('error', StackTrace.current),
          );
        },
        build: buildBloc,
        act: (bloc) => bloc.add(SignInWithGooglePressed()),
        expect: () => [
          LoginLoading(),
          GoogleLoginFailure(),
        ],
        verify: (_) {
          verify(() => authRepository.signInWithGoogle()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoading, GoogleLoginFailure] when generic '
        'exception occurs',
        setUp: () {
          when(() => authRepository.signInWithGoogle())
              .thenThrow(Exception('error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(SignInWithGooglePressed()),
        expect: () => [
          LoginLoading(),
          GoogleLoginFailure(),
        ],
        verify: (_) {
          verify(() => authRepository.signInWithGoogle()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'adds error to bloc when exception occurs',
        setUp: () {
          when(() => authRepository.signInWithGoogle())
              .thenThrow(Exception('error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(SignInWithGooglePressed()),
        errors: () => [isA<Exception>()],
      );
    });

    group('SignInWithApplePressed', () {
      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoading, LoginSuccess] when successful',
        setUp: () {
          when(() => authRepository.signInWithApple())
              .thenAnswer((_) async => mockUser);
        },
        build: buildBloc,
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
        'emits [LoginLoading, AppleLoginFailure] when '
        'SignInWithAppleException occurs',
        setUp: () {
          when(() => authRepository.signInWithApple())
              .thenThrow(SignInWithAppleException('error', StackTrace.current));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(SignInWithApplePressed()),
        expect: () => [
          LoginLoading(),
          AppleLoginFailure(),
        ],
        verify: (_) {
          verify(() => authRepository.signInWithApple()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginLoading, AppleLoginFailure] when generic exception occurs',
        setUp: () {
          when(() => authRepository.signInWithApple())
              .thenThrow(Exception('error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(SignInWithApplePressed()),
        expect: () => [
          LoginLoading(),
          AppleLoginFailure(),
        ],
        verify: (_) {
          verify(() => authRepository.signInWithApple()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'adds error to bloc when exception occurs',
        setUp: () {
          when(() => authRepository.signInWithApple())
              .thenThrow(Exception('error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(SignInWithApplePressed()),
        errors: () => [isA<Exception>()],
      );
    });
  });
}
