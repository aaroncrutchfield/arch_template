import 'package:arch_template/core/di/app_registry.dart';
import 'package:arch_template/features/login/bloc/login_bloc.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => appRegistry.get<LoginBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        // switch (state) {
        //   case LoginSuccess():
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Login Success')),
        //     );
        //   case LoginFailure():
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text(state.message)),
        //     );
        //   default:
        //     break;
        // }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => bloc.add(SignInWithGooglePressed()),
            child: const Text('Sign in with Google'),
          ),
          ElevatedButton(
            onPressed: () => bloc.add(SignInWithApplePressed()),
            child: const Text('Sign in with Apple'),
          ),
        ],
      ),
    );
  }
}
