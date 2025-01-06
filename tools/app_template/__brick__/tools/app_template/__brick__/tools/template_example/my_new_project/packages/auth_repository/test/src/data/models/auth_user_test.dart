import 'package:auth_repository/src/data/models/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AuthUser', () {
    const id = 'test-id';
    const email = 'test@example.com';
    const name = 'Test User';
    const photoUrl = 'https://example.com/photo.jpg';

    test('can be instantiated', () {
      expect(
        () => const AuthUser(
          id: id,
          email: email,
          name: name,
          photoUrl: photoUrl,
        ),
        returnsNormally,
      );
    });

    test('supports value equality', () {
      // Arrange
      const user1 = AuthUser(
        id: id,
        email: email,
        name: name,
        photoUrl: photoUrl,
      );
      const user2 = AuthUser(
        id: id,
        email: email,
        name: name,
        photoUrl: photoUrl,
      );

      // Act & Assert
      expect(user1, equals(user2));
    });

    group('fromFirebaseUser', () {
      late User mockUser;

      setUp(() {
        mockUser = MockUser();
      });

      test('creates correct user with all fields present', () {
        // Arrange
        when(() => mockUser.uid).thenReturn(id);
        when(() => mockUser.email).thenReturn(email);
        when(() => mockUser.displayName).thenReturn(name);
        when(() => mockUser.photoURL).thenReturn(photoUrl);

        // Act
        final authUser = AuthUser.fromFirebaseUser(mockUser);

        // Assert
        expect(authUser.id, equals(id));
        expect(authUser.email, equals(email));
        expect(authUser.name, equals(name));
        expect(authUser.photoUrl, equals(photoUrl));
      });

      test('creates correct user with null optional fields', () {
        // Arrange
        when(() => mockUser.uid).thenReturn(id);
        when(() => mockUser.email).thenReturn(null);
        when(() => mockUser.displayName).thenReturn(null);
        when(() => mockUser.photoURL).thenReturn(null);

        // Act
        final authUser = AuthUser.fromFirebaseUser(mockUser);

        // Assert
        expect(authUser.id, equals(id));
        expect(authUser.email, equals(''));
        expect(authUser.name, equals(''));
        expect(authUser.photoUrl, equals(''));
      });
    });

    test('toString returns correct string representation', () {
      // Arrange
      const user = AuthUser(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
      );

      // Act
      final result = user.toString();

      // Assert
      expect(
        result,
        'AuthUser(id: test-id, email: test@example.com, name: Test User, photoUrl: https://example.com/photo.jpg)',
      );
    });

    group('props', () {
      test('contains all properties', () {
        // Arrange
        const user = AuthUser(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
        );

        // Act & Assert
        expect(
          user.props,
          equals([
            'test-id',
            'test@example.com',
            'Test User',
            'https://example.com/photo.jpg',
          ]),
        );
      });

      test('equals returns true for identical users', () {
        // Arrange
        const user1 = AuthUser(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
        );
        const user2 = AuthUser(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
        );

        // Act & Assert
        expect(user1, equals(user2));
      });
    });
  });
}
