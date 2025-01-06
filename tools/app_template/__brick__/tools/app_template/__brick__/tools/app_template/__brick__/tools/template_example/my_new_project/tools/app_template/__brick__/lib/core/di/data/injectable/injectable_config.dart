// coverage:ignore-file
// This file is not testable because it generates code
import 'package:/core/di/data/injectable/injectable_config.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

/// Configures GetIt dependency injection for the application.
///
/// This class provides a way to configure dependencies for different
/// environments using the injectable package.
class InjectableConfig {
  /// Initializes all application dependencies using the specified environment.
  ///
  /// [environment] The environment to configure dependencies for
  /// (e.g., dev, prod).
  ///
  /// [getIt] The GetIt instance to configure.
  Future<void> configureDependencies(
    String environment,
    GetIt getIt,
  ) =>
      _configureAppDependencies(getIt, environment);
}

/// Internal function to initialize dependencies using injectable.
///
/// Uses the generated initialization code from injectable_generator.
/// [getIt] The GetIt instance to configure.
/// [environment] The environment to initialize dependencies for.
@InjectableInit(initializerName: 'init')
Future<void> _configureAppDependencies(
  GetIt getIt,
  String environment,
) async =>
    getIt.init(environment: environment);
