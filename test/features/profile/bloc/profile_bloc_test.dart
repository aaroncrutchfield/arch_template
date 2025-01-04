import 'package:arch_template/features/profile/bloc/profile_bloc.dart';
import 'package:arch_template/features/profile/models/user.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthUser extends Mock implements AuthUser {}

void main() {
  group('ProfileBloc', () {
    late AuthRepository authRepository;
    late AuthUser authUser;

    setUp(() {
      authRepository = MockAuthRepository();
      authUser = MockAuthUser();

      // Setup default auth state
      when(() => authRepository.authStateChanges())
          .thenAnswer((_) => Stream.value(authUser));

      when(() => authUser.id).thenReturn('test-id');
      when(() => authUser.email).thenReturn('test@example.com');
      when(() => authUser.name).thenReturn('Test User');
      when(() => authUser.photoUrl).thenReturn('https://example.com/photo.jpg');
    });

    test('initial state is ProfileInitial', () {
      expect(
        ProfileBloc(authRepository).state,
        equals(ProfileInitial()),
      );
    });

    group('ProfileStarted', () {
      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileLoaded] when user is authenticated',
        setUp: () {
          when(() => authRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(authUser));
        },
        build: () => ProfileBloc(authRepository),
        expect: () => [
          ProfileLoading(),
          const ProfileLoaded(
            user: User(
              email: 'test@example.com',
              name: 'Test User',
              photoUrl: 'https://example.com/photo.jpg',
            ),
          ),
        ],
        verify: (_) {
          verify(() => authRepository.authStateChanges()).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileError] when user is not authenticated',
        setUp: () {
          when(() => authRepository.authStateChanges())
              .thenAnswer((_) => Stream.value(null));
        },
        build: () => ProfileBloc(authRepository),
        expect: () => [
          ProfileLoading(),
          const ProfileError(message: 'User not found'),
        ],
        verify: (_) {
          verify(() => authRepository.authStateChanges()).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileError] when error occurs',
        setUp: () {
          when(() => authRepository.authStateChanges())
              .thenAnswer((_) => Stream.error('Auth error'));
        },
        build: () => ProfileBloc(authRepository),
        expect: () => [
          ProfileLoading(),
          const ProfileError(message: 'Auth error'),
        ],
        errors: () => ['Auth error'],
        verify: (_) {
          verify(() => authRepository.authStateChanges()).called(1);
        },
      );
    });

    group('ProfileSignOutRequested', () {
      blocTest<ProfileBloc, ProfileState>(
        'signs out user successfully',
        setUp: () {
          when(() => authRepository.signOut()).thenAnswer((_) async {});
        },
        build: () => ProfileBloc(authRepository),
        seed: () => const ProfileLoaded(
          user: User(
            email: 'test@example.com',
            name: 'Test User',
            photoUrl: 'https://example.com/photo.jpg',
          ),
        ),
        act: (bloc) => bloc.add(const ProfileSignOutRequested()),
        verify: (_) {
          verify(() => authRepository.signOut()).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileError] when sign out fails',
        setUp: () {
          when(() => authRepository.signOut())
              .thenThrow(Exception('Sign out failed'));
        },
        build: () => ProfileBloc(authRepository),
        seed: () => const ProfileLoaded(
          user: User(
            email: 'test@example.com',
            name: 'Test User',
            photoUrl: 'https://example.com/photo.jpg',
          ),
        ),
        skip: 2,
        act: (bloc) => bloc.add(const ProfileSignOutRequested()),
        expect: () => [
          const ProfileError(message: 'Exception: Sign out failed'),
        ],
        errors: () => [isA<Exception>()],
        verify: (_) {
          verify(() => authRepository.signOut()).called(1);
        },
      );
    });

    group('ProfileEditRequested', () {
      blocTest<ProfileBloc, ProfileState>(
        'does nothing yet (TODO)',
        build: () => ProfileBloc(authRepository),
        seed: () => const ProfileLoaded(
          user: User(
            email: 'test@example.com',
            name: 'Test User',
            photoUrl: 'https://example.com/photo.jpg',
          ),
        ),
        act: (bloc) => bloc.add(const ProfileEditRequested()),
      );
    });

    group('ProfileSettingsRequested', () {
      blocTest<ProfileBloc, ProfileState>(
        'does nothing yet (TODO)',
        build: () => ProfileBloc(authRepository),
        seed: () => const ProfileLoaded(
          user: User(
            email: 'test@example.com',
            name: 'Test User',
            photoUrl: 'https://example.com/photo.jpg',
          ),
        ),
        act: (bloc) => bloc.add(const ProfileSettingsRequested()),
      );
    });
  });
}
