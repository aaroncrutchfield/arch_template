import 'package:flutter_test/flutter_test.dart';
import 'package:user_repository/src/data/models/models.dart';

void main() {
  group('UserEntity', () {
    const uid = 'test-uid';
    const username = 'test-username';
    const email = 'test@example.com';
    const isOnboardComplete = true;

    test('can be instantiated', () {
      expect(
        () => const UserEntity(
          uid: uid,
          username: username,
          email: email,
          isOnboardComplete: isOnboardComplete,
        ),
        returnsNormally,
      );
    });

    test('supports value equality', () {
      expect(
        const UserEntity(
          uid: uid,
          username: username,
          email: email,
          isOnboardComplete: isOnboardComplete,
        ),
        equals(
          const UserEntity(
            uid: uid,
            username: username,
            email: email,
            isOnboardComplete: isOnboardComplete,
          ),
        ),
      );
    });

    group('copyWith', () {
      const user = UserEntity(
        uid: uid,
        username: username,
        email: email,
        isOnboardComplete: isOnboardComplete,
      );

      test('returns the same object if no parameters are passed', () {
        expect(user.copyWith(), equals(user));
      });

      test('returns a new object with updated uid', () {
        expect(
          user.copyWith(uid: 'new-uid'),
          equals(
            const UserEntity(
              uid: 'new-uid',
              username: username,
              email: email,
              isOnboardComplete: isOnboardComplete,
            ),
          ),
        );
      });

      test('returns a new object with updated username', () {
        expect(
          user.copyWith(username: 'new-username'),
          equals(
            const UserEntity(
              uid: uid,
              username: 'new-username',
              email: email,
              isOnboardComplete: isOnboardComplete,
            ),
          ),
        );
      });

      test('returns a new object with updated email', () {
        expect(
          user.copyWith(email: 'new@example.com'),
          equals(
            const UserEntity(
              uid: uid,
              username: username,
              email: 'new@example.com',
              isOnboardComplete: isOnboardComplete,
            ),
          ),
        );
      });

      test('returns a new object with updated isOnboardComplete', () {
        expect(
          user.copyWith(isOnboardComplete: false),
          equals(
            const UserEntity(
              uid: uid,
              username: username,
              email: email,
              isOnboardComplete: false,
            ),
          ),
        );
      });
    });

    test('toString returns correct string representation', () {
      expect(
        const UserEntity(
          uid: uid,
          username: username,
          email: email,
          isOnboardComplete: isOnboardComplete,
        ).toString(),
        equals(
          'UserEntity(uid: test-uid, username: test-username, '
          'email: test@example.com, isOnboardComplete: true)',
        ),
      );
    });
  });
}
