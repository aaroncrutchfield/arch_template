import 'package:{{project_name.snakeCase}}/core/di/app_registry.dart';
import 'package:{{project_name.snakeCase}}/core/navigation/navigation.dart';
import 'package:{{project_name.snakeCase}}/features/auth/bloc/auth_bloc.dart';
import 'package:{{project_name.snakeCase}}/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: appRegistry.get<AppNavigation>(),
      child: BlocProvider.value(
        value: appRegistry.get<AuthBloc>(),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = context.read<AppNavigation>();
    final colorScheme = ColorScheme.fromSeed(
      brightness: MediaQuery.platformBrightnessOf(context),
      seedColor: Colors.orange,
    );

    return MaterialApp.router(
      routerConfig: navigation.routerConfig(),
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
