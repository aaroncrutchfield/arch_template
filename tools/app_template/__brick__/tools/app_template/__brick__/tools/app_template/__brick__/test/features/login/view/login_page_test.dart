import 'dart:async';

import 'package:{{project_name.snakeCase}}/core/di/app_registry.dart';
import 'package:{{project_name.snakeCase}}/core/di/domain/injection_registry.dart';
import 'package:{{project_name.snakeCase}}/features/login/bloc/login_bloc.dart';
import 'package:{{project_name.snakeCase}}/features/login/view/login_page.dart';
import 'package:{{project_name.snakeCase}}/l10n/l10n.dart';
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

  late LoginBloc loginBloc;
  late AppLocalizations l10n;

  setUp(() {
    loginBloc = MockLoginBloc();
    l10n = MockAppLocalizations();

    // Setup default bloc state
    when(() => loginBloc.state).thenReturn(LoginInitial());

    // Setup default l10n strings
    when(() => l10n.signInWithGoogle).thenReturn('Sign in with Google');
    when(() => l10n.signInWithApple).thenReturn('Sign in with Apple');
    when(() => l10n.signInWithGoogleFailed).thenReturn('Google sign in failed');
    when(() => l10n.signInWithAppleFailed).thenReturn('Apple sign in failed');

    appRegistry.register<LoginBloc>(() => loginBloc);

    // Register test doubles
    registerFallbackValue(LoginInitial());
    registerFallbackValue(SignInWithGooglePressed());
    registerFallbackValue(SignInWithApplePressed());
  });

  tearDown(appRegistry.reset);

  group('LoginPage', () {
    testWidgets('renders LoginView', (tester) async {
      await tester.pumpApp(const LoginPage());

      expect(find.byType(LoginView), findsOneWidget);
    });

    testWidgets('provides LoginBloc from registry', (tester) async {
      await tester.pumpApp(const LoginPage());

      expect(
        find.byWidgetPredicate(
          (widget) => widget is BlocProvider<LoginBloc>,
        ),
        findsOneWidget,
      );
    });
  });

  group('LoginView', () {
    Future<void> pumpLoginView(WidgetTester tester) {
      return tester.pumpApp(
        BlocProvider.value(
          value: loginBloc,
          child: const Scaffold(body: LoginView()),
        ),
      );
    }

    testWidgets('renders sign in buttons with correct text', (tester) async {
      await pumpLoginView(tester);

      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.text('Sign in with Apple'), findsOneWidget);
    });

    group('Google sign in', () {
      testWidgets('adds SignInWithGooglePressed when button is tapped',
          (tester) async {
        await pumpLoginView(tester);

        await tester.tap(find.text('Sign in with Google'));
        await tester.pump();

        verify(() => loginBloc.add(SignInWithGooglePressed())).called(1);
      });

      testWidgets('shows snackbar with correct message on GoogleLoginFailure',
          (tester) async {
        final controller = StreamController<LoginState>();
        whenListen(
          loginBloc,
          controller.stream,
          initialState: LoginInitial(),
        );

        await pumpLoginView(tester);

        controller.add(GoogleLoginFailure());
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Google Sign In failed'), findsOneWidget);

        await controller.close();
      });

      testWidgets('disables button during loading state', (tester) async {
        when(() => loginBloc.state).thenReturn(LoginLoading());

        await pumpLoginView(tester);

        final button =
            find.widgetWithText(ElevatedButton, 'Sign in with Google');
        expect(
          tester.widget<ElevatedButton>(button).enabled,
          isFalse,
          reason: 'Google sign-in button should be disabled during loading',
        );
      });
    });

    group('Apple sign in', () {
      testWidgets('adds SignInWithApplePressed when button is tapped',
          (tester) async {
        await pumpLoginView(tester);

        await tester.tap(find.text('Sign in with Apple'));
        await tester.pump();

        verify(() => loginBloc.add(SignInWithApplePressed())).called(1);
      });

      testWidgets('shows snackbar with correct message on AppleLoginFailure',
          (tester) async {
        final controller = StreamController<LoginState>();
        whenListen(
          loginBloc,
          controller.stream,
          initialState: LoginInitial(),
        );

        await pumpLoginView(tester);

        controller.add(AppleLoginFailure());
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Apple Sign In failed'), findsOneWidget);

        await controller.close();
      });

      testWidgets('disables button during loading state', (tester) async {
        when(() => loginBloc.state).thenReturn(LoginLoading());

        await pumpLoginView(tester);

        final button =
            find.widgetWithText(ElevatedButton, 'Sign in with Apple');
        expect(
          tester.widget<ElevatedButton>(button).enabled,
          isFalse,
          reason: 'Apple sign-in button should be disabled during loading',
        );
      });
    });

    group('loading state', () {
      testWidgets('disables both buttons during loading', (tester) async {
        when(() => loginBloc.state).thenReturn(LoginLoading());

        await pumpLoginView(tester);

        final buttons = find.byType(ElevatedButton);
        expect(buttons, findsNWidgets(2));

        for (final button in tester.widgetList<ElevatedButton>(buttons)) {
          expect(button.enabled, isFalse);
        }
      });
    });

    group('success state', () {
      testWidgets('does not show snackbar on LoginSuccess', (tester) async {
        final controller = StreamController<LoginState>();
        whenListen(
          loginBloc,
          controller.stream,
          initialState: LoginInitial(),
        );

        await pumpLoginView(tester);

        controller.add(LoginSuccess());
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsNothing);

        await controller.close();
      });
    });
  });
}
