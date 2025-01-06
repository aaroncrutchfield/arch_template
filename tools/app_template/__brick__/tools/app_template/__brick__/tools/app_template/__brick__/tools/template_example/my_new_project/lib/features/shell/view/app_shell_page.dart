// coverage:ignore-file

import 'package:/core/navigation/data/auto_router.gr.dart';
import 'package:/features/shell/widgets/widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AppShellPage extends StatelessWidget {
  const AppShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        CounterRoute(),
        ProfileRoute(),
      ],
      transitionBuilder: (context, selectedPage, animation) => FadeTransition(
        opacity: animation,
        child: selectedPage,
      ),
      builder: (ctx, widget) {
        final tabsRouter = ctx.tabsRouter;
        return Scaffold(
          body: widget,
          bottomNavigationBar: AppNavigationBar(
            tabsRouter: tabsRouter,
          ),
        );
      },
    );
  }
}
