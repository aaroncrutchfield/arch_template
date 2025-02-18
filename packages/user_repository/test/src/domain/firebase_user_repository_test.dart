// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/src/data/models/models.dart';
import 'package:user_repository/src/domain/firebase_user_repository.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference<T> extends Mock
    implements CollectionReference<T> {}

class MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {}

class MockQuery<T> extends Mock implements Query<T> {}

class MockQueryDocumentSnapshot<T> extends Mock
    implements QueryDocumentSnapshot<T> {}

class MockDocumentReference<T> extends Mock implements DocumentReference<T> {}

class MockDocumentSnapshot<T> extends Mock implements DocumentSnapshot<T> {}

void main() {
  group('UserEntityFirebaseX', () {
    const user = UserEntity(
      uid: 'test-uid',
      username: 'test-username',
      email: 'test@example.com',
      isOnboardComplete: true,
    );

    test('toFirestore returns correct map', () {
      final result = user.toFirestore();
      expect(
        result,
        equals({
          'uid': 'test-uid',
          'username': 'test-username',
          'email': 'test@example.com',
          'isOnboardComplete': true,
        }),
      );
    });
  });

  group('UserEntityFirebaseConverter', () {
    test('fromFirestore creates correct UserEntity', () {
      final snapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      when(() => snapshot.id).thenReturn('test-uid');
      when(snapshot.data).thenReturn({
        'username': 'test-username',
        'email': 'test@example.com',
        'isOnboardComplete': true,
      });

      final result = UserEntityFirebaseConverter.fromFirestore(snapshot, null);

      expect(
        result,
        equals(
          const UserEntity(
            uid: 'test-uid',
            username: 'test-username',
            email: 'test@example.com',
            isOnboardComplete: true,
          ),
        ),
      );
    });

    test('toFirestore converts correctly', () {
      const user = UserEntity(
        uid: 'test-uid',
        username: 'test-username',
        email: 'test@example.com',
        isOnboardComplete: true,
      );

      final result = UserEntityFirebaseConverter.toFirestore(user, null);
      expect(result, equals(user.toFirestore()));
    });
  });

  group('FirebaseUserRepository', () {
    late FirebaseFirestore firestore;
    late FirebaseUserRepository repository;
    late CollectionReference<UserEntity> collection;
    late CollectionReference<Map<String, dynamic>> collectionMap;
    late Query<UserEntity> query;

    setUp(() {
      firestore = MockFirebaseFirestore();
      collection = MockCollectionReference<UserEntity>();
      collectionMap = MockCollectionReference<Map<String, dynamic>>();
      query = MockQuery<UserEntity>();
      repository = FirebaseUserRepository(firestore);

      when(() => firestore.collection('users')).thenReturn(collectionMap);
      when(
        () => collectionMap.withConverter<UserEntity>(
          fromFirestore: any(named: 'fromFirestore'),
          toFirestore: any(named: 'toFirestore'),
        ),
      ).thenReturn(collection);
    });

    group('getUser', () {
      test('returns null when no user is found', () async {
        final querySnapshot = MockQuerySnapshot<UserEntity>();

        when(
          () => collection.where('email', isEqualTo: any(named: 'isEqualTo')),
        ).thenReturn(query);
        when(() => query.limit(1)).thenReturn(query);
        when(() => query.get()).thenAnswer((_) async => querySnapshot);
        when(() => querySnapshot.docs).thenReturn([]);

        final result = await repository.getUser('test@example.com');
        expect(result, isNull);
      });

      test('returns user when found', () async {
        const user = UserEntity(
          uid: 'test-uid',
          username: 'test-username',
          email: 'test@example.com',
          isOnboardComplete: true,
        );

        final querySnapshot = MockQuerySnapshot<UserEntity>();
        final queryDocSnapshot = MockQueryDocumentSnapshot<UserEntity>();

        when(
          () => collection.where('email', isEqualTo: any(named: 'isEqualTo')),
        ).thenReturn(query);
        when(() => query.limit(1)).thenReturn(query);
        when(() => query.get()).thenAnswer((_) async => querySnapshot);
        when(() => querySnapshot.docs).thenReturn([queryDocSnapshot]);
        when(queryDocSnapshot.data).thenReturn(user);

        final result = await repository.getUser('test@example.com');
        expect(result, equals(user));
      });

      test('throws GetUserException on error', () async {
        when(
          () => collection.where('email', isEqualTo: any(named: 'isEqualTo')),
        ).thenReturn(query);
        when(() => query.limit(1)).thenReturn(query);
        when(() => query.get()).thenThrow(Exception('test error'));

        expect(
          () => repository.getUser('test@example.com'),
          throwsA(isA<GetUserException>()),
        );
      });
    });

    group('updateUser', () {
      test('updates user successfully', () async {
        const user = UserEntity(
          uid: 'test-uid',
          username: 'test-username',
          email: 'test@example.com',
          isOnboardComplete: true,
        );

        final docRef = MockDocumentReference<UserEntity>();
        when(() => collection.doc(user.uid)).thenReturn(docRef);
        when(() => docRef.set(user)).thenAnswer((_) async {});

        await expectLater(
          repository.updateUser(user),
          completes,
        );

        verify(() => docRef.set(user)).called(1);
      });

      test('throws UpdateUserException on error', () async {
        const user = UserEntity(
          uid: 'test-uid',
          username: 'test-username',
          email: 'test@example.com',
          isOnboardComplete: true,
        );

        final docRef = MockDocumentReference<UserEntity>();
        when(() => collection.doc(user.uid)).thenReturn(docRef);
        when(() => docRef.set(user)).thenThrow(Exception('test error'));

        expect(
          () => repository.updateUser(user),
          throwsA(isA<UpdateUserException>()),
        );
      });
    });

    group('userChanges', () {
      test('emits null when no user is found', () async {
        final querySnapshot = MockQuerySnapshot<UserEntity>();

        when(
          () => collection.where('email', isEqualTo: any(named: 'isEqualTo')),
        ).thenReturn(query);
        when(() => query.limit(1)).thenReturn(query);
        when(() => query.snapshots())
            .thenAnswer((_) => Stream.value(querySnapshot));
        when(() => querySnapshot.docs).thenReturn([]);

        await expectLater(
          repository.userChanges('test@example.com'),
          emits(null),
        );
      });

      test('emits user when found', () async {
        const user = UserEntity(
          uid: 'test-uid',
          username: 'test-username',
          email: 'test@example.com',
          isOnboardComplete: true,
        );

        final querySnapshot = MockQuerySnapshot<UserEntity>();
        final queryDocSnapshot = MockQueryDocumentSnapshot<UserEntity>();

        when(
          () => collection.where('email', isEqualTo: any(named: 'isEqualTo')),
        ).thenReturn(query);
        when(() => query.limit(1)).thenReturn(query);
        when(() => query.snapshots())
            .thenAnswer((_) => Stream.value(querySnapshot));
        when(() => querySnapshot.docs).thenReturn([queryDocSnapshot]);
        when(queryDocSnapshot.data).thenReturn(user);

        await expectLater(
          repository.userChanges('test@example.com'),
          emits(user),
        );
      });

      test('throws GetUserException on error', () {
        when(
          () => collection.where('email', isEqualTo: any(named: 'isEqualTo')),
        ).thenReturn(query);
        when(() => query.limit(1)).thenReturn(query);
        when(() => query.snapshots()).thenThrow(Exception('test error'));

        expect(
          () => repository.userChanges('test@example.com'),
          throwsA(isA<GetUserException>()),
        );
      });
    });
  });
}
