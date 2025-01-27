import 'dart:async';
import 'dart:developer';

import 'package:arch_template/app/environments.dart';
import 'package:arch_template/core/di/app_registry.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    final message = 'onChange(${bloc.runtimeType})\n$change';
    log(message);
    FirebaseCrashlytics.instance.log(message);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType})', error: error, stackTrace: stackTrace);
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      information: [
        'Bloc: ${bloc.runtimeType}',
        'State: ${bloc.state}',
      ],
    );
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap({
  required Environment environment,
  required FutureOr<Widget> Function() builder,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await appRegistry.init(environment);
  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  runApp(await builder());
}
