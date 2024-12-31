import 'package:arch_template/core/navigation/data/auto_router.dart';
import 'package:arch_template/core/navigation/data/auto_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RootAutoRouter', () {
    late RootAutoRouter sut;

    setUp(() {
      sut = RootAutoRouter();
    });

    group('defaultRouteType', () {
      test('should return adaptive route type', () {
        // Act
        final result = sut.defaultRouteType;

        // Assert
        expect(result, isA<RouteType>());
        expect(result, equals(const RouteType.adaptive()));
      });
    });

    group('routes', () {
      test('the initial route is the login page', () {
        // Act
        final routes = sut.routes;

        // Assert
        final initialRoute = routes.first;
        expect(initialRoute.path, equals('/login'));
        expect(initialRoute.page, equals(LoginRoute.page));
        expect(initialRoute.initial, isTrue);
      });
    });
  });
}
