import 'package:arch_template/core/di/app_registry.dart';
import 'package:arch_template/features/common/extensions/context.dart';
import 'package:arch_template/features/login/bloc/login_bloc.dart';
import 'package:arch_template/l10n/l10n.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => appRegistry.get<LoginBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (ctx, state) {
        return switch (state) {
          GoogleLoginFailure() => ctx.showSnackBar(
              SnackBar(content: Text(ctx.l10n.signInWithGoogleFailed)),
            ),
          AppleLoginFailure() => ctx.showSnackBar(
              SnackBar(content: Text(ctx.l10n.signInWithAppleFailed)),
            ),
          _ => null,
        };
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        final bloc = context.read<LoginBloc>();
        final l10n = context.l10n;

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => bloc.add(SignInWithGooglePressed()),
                  child: Text(l10n.signInWithGoogle),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => bloc.add(SignInWithApplePressed()),
                  child: Text(l10n.signInWithApple),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
