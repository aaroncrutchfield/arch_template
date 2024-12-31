import 'dart:async';

import 'package:arch_template/core/di/app_registry.dart';
import 'package:arch_template/core/di/domain/injection_registry.dart';
import 'package:arch_template/features/login/bloc/login_bloc.dart';
import 'package:arch_template/features/login/view/login_page.dart';
import 'package:arch_template/l10n/l10n.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockAppLocalizations extends Mock implements AppLocalizations {}

class MockInjectionRegistry extends Mock implements InjectionRegistry {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginPage', () {
    late LoginBloc loginBloc;

    setUp(() {
      loginBloc = MockLoginBloc();

      // Setup default bloc state
      when(() => loginBloc.state).thenReturn(LoginInitial());

      appRegistry.register<LoginBloc>(() => loginBloc);

      // Register test doubles
      registerFallbackValue(LoginInitial());
      registerFallbackValue(SignInWithGooglePressed());
      registerFallbackValue(SignInWithApplePressed());
    });

    tearDown(appRegistry.reset);

    testWidgets('renders LoginView', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: loginBloc,
          child: const LoginPage(),
        ),
      );

      expect(find.byType(LoginView), findsOneWidget);
    });

    group('LoginView', () {
      testWidgets('renders sign in buttons', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginView(),
          ),
        );

        expect(find.text('Sign in with Google'), findsOneWidget);
        expect(find.text('Sign in with Apple'), findsOneWidget);
      });

      testWidgets('adds SignInWithGooglePressed when Google button is tapped',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginView(),
          ),
        );

        await tester.tap(find.text('Sign in with Google'));
        await tester.pump();

        verify(() => loginBloc.add(SignInWithGooglePressed())).called(1);
      });

      testWidgets('adds SignInWithApplePressed when Apple button is tapped',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginView(),
          ),
        );

        await tester.tap(find.text('Sign in with Apple'));
        await tester.pump();

        verify(() => loginBloc.add(SignInWithApplePressed())).called(1);
      });

      testWidgets('shows snackbar when state is LoginFailure', (tester) async {
        const errorMessage = 'Sign in failed';

        // Create a stream controller to emit states
        final controller = StreamController<LoginState>();
        whenListen(
          loginBloc,
          controller.stream,
          initialState: LoginInitial(),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const Scaffold(body: LoginView()),
          ),
        );

        // Emit the failure state
        controller.add(const LoginFailure(errorMessage));
        await tester.pump();

        // Verify snackbar is shown with error message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);

        // Clean up
        await controller.close();
      });

      testWidgets('disables buttons during loading state', (tester) async {
        when(() => loginBloc.state).thenReturn(LoginLoading());

        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginView(),
          ),
        );

        final googleButton =
            find.widgetWithText(ElevatedButton, 'Sign in with Google');
        final appleButton =
            find.widgetWithText(ElevatedButton, 'Sign in with Apple');

        expect(
          tester.widget<ElevatedButton>(googleButton).enabled,
          isFalse,
          reason: 'Google sign-in button should be disabled during loading',
        );
        expect(
          tester.widget<ElevatedButton>(appleButton).enabled,
          isFalse,
          reason: 'Apple sign-in button should be disabled during loading',
        );
      });
    });
  });
}
