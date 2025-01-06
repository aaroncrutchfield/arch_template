import 'package:/core/di/data/injectable/annotations.dart'
    as config;

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Environment Annotations', () {
    test('Development environment annotation is correct', () {
      expect(config.development.name, 'development');
    });

    test('Staging environment annotation is correct', () {
      expect(config.staging.name, 'staging');
    });

    test('Production environment annotation is correct', () {
      expect(config.production.name, 'production');
    });
  });
}
