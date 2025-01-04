import 'package:arch_template/features/shell/widgets/widgets.dart';
import 'package:arch_template/l10n/l10n.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class MockTabsRouter extends Mock implements TabsRouter {}

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  group('AppNavigationBar', () {
    late TabsRouter tabsRouter;
    late AppLocalizations l10n;

    setUp(() {
      tabsRouter = MockTabsRouter();
      l10n = MockAppLocalizations();

      when(() => tabsRouter.activeIndex).thenReturn(0);
      when(() => tabsRouter.setActiveIndex(any())).thenAnswer((_) async {});
      when(() => l10n.counter).thenReturn('Counter');
      when(() => l10n.profile).thenReturn('Profile');
    });

    testWidgets('renders navigation bar with correct destinations',
        (tester) async {
      await tester.pumpApp(
        AppNavigationBar(tabsRouter: tabsRouter),
      );

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.numbers), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('displays correct labels from l10n', (tester) async {
      await tester.pumpApp(
        AppNavigationBar(tabsRouter: tabsRouter),
      );

      expect(find.text('Counter'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('sets correct active index', (tester) async {
      when(() => tabsRouter.activeIndex).thenReturn(1);

      await tester.pumpApp(
        AppNavigationBar(tabsRouter: tabsRouter),
      );

      final navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navigationBar.selectedIndex, equals(1));
    });

    testWidgets('calls setActiveIndex when destination is selected',
        (tester) async {
      await tester.pumpApp(
        AppNavigationBar(tabsRouter: tabsRouter),
      );

      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();

      verify(() => tabsRouter.setActiveIndex(1)).called(1);
    });
  });
}
