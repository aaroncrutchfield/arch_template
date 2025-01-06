import 'package:/l10n/l10n.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// A widget that displays the bottom navigation bar for the app shell.
class AppNavigationBar extends StatelessWidget {
  /// Creates an [AppNavigationBar].
  const AppNavigationBar({
    required this.tabsRouter,
    super.key,
  });

  /// The tabs router that manages the navigation state.
  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NavigationBar(
      selectedIndex: tabsRouter.activeIndex,
      onDestinationSelected: tabsRouter.setActiveIndex,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.numbers),
          label: l10n.counter,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person),
          label: l10n.profile,
        ),
      ],
    );
  }
}
