import 'package:/app/environments.dart';

/// Interface for managing dependency injection in the application.
abstract interface class InjectionRegistry {
  /// Initializes the dependency injection container for the given environment.
  ///
  /// [environment] The environment to initialize dependencies for.
  Future<void> init(Environment environment);

  /// Retrieves a dependency of type [T] from the container.
  ///
  /// Optional [param1] and [param2] can be passed for factory functions.
  T get<T extends Object>({
    dynamic param1,
    dynamic param2,
  });

  /// Shorthand operator for retrieving dependencies.
  ///
  /// Functions identically to [get].
  T call<T extends Object>({
    dynamic param1,
    dynamic param2,
  });

  /// Resets the dependency container to its initial state.
  void reset();

  /// Registers a factory function for type [T].
  ///
  /// Only available for testing purposes.
  void register<T extends Object>(T Function() factoryFunction);
}
