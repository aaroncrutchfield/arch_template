import 'package:arch_template/app/environments.dart';
import 'package:arch_template/core/di/data/get_it/get_it_registry_source.dart';
import 'package:arch_template/core/di/domain/injection_registry.dart';
import 'package:flutter/foundation.dart';

/// Implementation of [InjectionRegistry] using GetIt for dependency injection.
///
/// This class provides a way to access and manage dependencies across the
/// application using GetIt.
class GetItInjectionRegistry implements InjectionRegistry {
  /// Creates a new instance with the provided registry source.
  const GetItInjectionRegistry(this.registrySource);

  /// The underlying source for registry operations.
  final GetItRegistrySource registrySource;

  @override
  Future<void> init(Environment environment) => registrySource.init(
        environment,
      );

  @override
  T get<T extends Object>({
    dynamic param1,
    dynamic param2,
  }) =>
      registrySource.get<T>(param1: param1, param2: param2);

  @override
  void reset() => registrySource.reset();

  @override
  T call<T extends Object>({
    dynamic param1,
    dynamic param2,
  }) =>
      registrySource.call<T>(param1: param1, param2: param2);

  @override
  @visibleForTesting
  void register<T extends Object>(T Function() factoryFunction) {
    registrySource.register(factoryFunction);
  }
}
