import 'package:{{project_name.snakeCase}}/core/di/data/get_it/get_it_registry_source.dart';
import 'package:{{project_name.snakeCase}}/core/di/data/injectable/injectable_config.dart';
import 'package:{{project_name.snakeCase}}/core/di/domain/get_it_injection_registry.dart';
import 'package:{{project_name.snakeCase}}/core/di/domain/injection_registry.dart';
import 'package:get_it/get_it.dart';

/// The application registry instance.
///
/// This instance provides a way to access and manage dependencies across the
/// application.
final InjectionRegistry appRegistry = GetItInjectionRegistry(
  GetItRegistrySource(GetIt.instance, InjectableConfig()),
);
