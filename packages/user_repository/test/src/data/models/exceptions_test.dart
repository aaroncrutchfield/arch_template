import 'package:flutter_test/flutter_test.dart';
import 'package:user_repository/src/data/models/models.dart';

void main() {
  group('UserException', () {
    test('GetUserException toString includes error and stack trace', () {
      final error = Exception('test error');
      final stackTrace = StackTrace.current;
      final exception = GetUserException(error, stackTrace);

      expect(
        exception.toString(),
        equals('GetUserException: $error\n$stackTrace'),
      );
    });

    test('UpdateUserException toString includes error and stack trace', () {
      final error = Exception('test error');
      final stackTrace = StackTrace.current;
      final exception = UpdateUserException(error, stackTrace);

      expect(
        exception.toString(),
        equals('UpdateUserException: $error\n$stackTrace'),
      );
    });
  });
}
