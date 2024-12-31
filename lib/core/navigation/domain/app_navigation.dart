import 'package:flutter/widgets.dart';

/// Navigation interface that abstracts routing functionality 
/// for the application.
///
/// This interface provides a common contract for implementing 
/// navigation solutions,
/// making it easier to switch between different routing implementations.
abstract interface class AppNavigation {
  /// Returns the router configuration for the application.
  ///
  /// Used to set up the application's routing system at the root level.
  RouterConfig<Object>? routerConfig();

  /// Navigates to a route by its name.
  ///
  /// [name] is the name of the route to navigate to.
  /// Returns a [Future] that completes when the navigation is complete.
  Future<void> navigateNamed(String name);

  /// Pushes a named route onto the navigation stack.
  ///
  /// [name] is the name of the route to push.
  /// Returns a [Future] that completes with the result value when 
  /// the route is popped.
  Future<T?> pushNamed<T extends Object?>(String name);

  /// Attempts to pop the current route off the navigation stack.
  ///
  /// [result] is an optional value to pass back to the previous route.
  /// Returns a [Future<bool>] indicating whether the pop was successful.
  Future<bool> maybePop<T extends Object?>([T? result]);

  /// Replaces the current route with a new named route.
  ///
  /// [name] is the name of the route to replace with.
  void replaceNamed(String name);
}
