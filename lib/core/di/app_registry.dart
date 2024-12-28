
import 'package:arch_template/core/di/data/get_it/get_it_registry_source.dart';
import 'package:arch_template/core/di/data/injectable/injectable_config.dart';
import 'package:arch_template/core/di/domain/get_it_injection_registry.dart';
import 'package:arch_template/core/di/domain/injection_registry.dart';
import 'package:get_it/get_it.dart';

/// The application registry instance.
///
/// This instance provides a way to access and manage dependencies across the
/// application.
final InjectionRegistry appRegistry = GetItInjectionRegistry(
  GetItRegistrySource(GetIt.instance, InjectableConfig()),
);
