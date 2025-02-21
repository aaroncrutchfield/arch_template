import 'dart:io' show Platform;

import 'package:arch_template/core/di/app_registry.dart';
import 'package:arch_template/core/navigation/navigation.dart';
import 'package:arch_template/features/auth/bloc/auth_bloc.dart';
import 'package:arch_template/features/notifications/bloc/notifications_bloc.dart';
import 'package:arch_template/features/theme/bloc/theme_bloc.dart';
import 'package:arch_template/l10n/l10n.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrader/upgrader.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: appRegistry.get<AppNavigation>(),
        ),
        RepositoryProvider.value(
          value: appRegistry.get<FirebaseAnalyticsObserver>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: appRegistry.get<AuthBloc>()),
          BlocProvider.value(value: appRegistry.get<NotificationsBloc>()),
          BlocProvider.value(value: appRegistry.get<ThemeBloc>()),
        ],
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
    final analyticsObserver = context.read<FirebaseAnalyticsObserver>();

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = (state is ThemeLoaded) && state.isDarkMode;

        return MaterialApp.router(
          routerConfig: navigation.routerConfig([analyticsObserver]),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              brightness: isDark ? Brightness.dark : Brightness.light,
              seedColor: Colors.orange,
            ),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => UpgradeAlert(
            dialogStyle: Platform.isIOS
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material,
            navigatorKey: navigation.navigatorKey,
            upgrader: Upgrader(),
            child: child,
          ),
        );
      },
    );
  }
}
