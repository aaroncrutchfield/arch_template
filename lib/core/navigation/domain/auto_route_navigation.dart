import 'package:arch_template/core/navigation/data/auto_router.dart';
import 'package:arch_template/core/navigation/domain/app_navigation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

/// Implementation of [AppNavigation] using AutoRoute for routing.
///
/// This class provides concrete implementations of navigation methods
/// using the AutoRoute library's functionality.
@Singleton(as: AppNavigation)
class AutoRouteNavigation implements AppNavigation {
  /// Creates a new instance of [AutoRouteNavigation].
  ///
  /// Requires a [RootAutoRouter] instance for handling the actual navigation.
  AutoRouteNavigation(this._router);

  /// The underlying router instance used for navigation.
  final RootAutoRouter _router;

  @override
  RouterConfig<Object> routerConfig([
    List<NavigatorObserver>? navigatorObservers,
  ]) =>
      _router.config(
        navigatorObservers: () => navigatorObservers ?? const [],
      );

  @override
  Future<void> navigateNamed(String name) => _router.navigateNamed(name);

  @override
  Future<T?> pushNamed<T extends Object?>(String name) =>
      _router.pushNamed(name);

  @override
  Future<bool> maybePop<T extends Object?>([T? result]) =>
      _router.maybePop(result);

  @override
  void replaceNamed(String name) => _router.replaceNamed(name);
}
