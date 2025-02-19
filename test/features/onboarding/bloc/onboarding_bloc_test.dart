import 'package:arch_template/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:arch_template/features/onboarding/models/models.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserEntity extends Mock implements UserEntity {}

class MockAuthUser extends Mock implements AuthUser {}

void main() {
  late OnboardingBloc bloc;
  late UserRepository userRepository;
  late AuthRepository authRepository;
  late OnboardingConfig config;
  late UserEntity mockUser;
  late AuthUser mockAuthUser;

  setUp(() {
    userRepository = MockUserRepository();
    authRepository = MockAuthRepository();
    mockUser = MockUserEntity();
    mockAuthUser = MockAuthUser();

    // Setup default config with 3 pages
    config = OnboardingConfig(
      pages: List.generate(
        3,
        (index) => OnboardingInfo(
          title: 'Page $index',
          description: 'Description $index',
        ),
      ),
    );

    // Setup default mocks
    when(() => authRepository.currentUser).thenReturn(mockAuthUser);
    when(() => mockAuthUser.id).thenReturn('test-user-id');
    when(() => userRepository.getUser(any())).thenAnswer((_) async => mockUser);
    when(() => mockUser.copyWith(isOnboardComplete: true)).thenReturn(mockUser);
    when(() => userRepository.updateUser(any())).thenAnswer((_) async {});

    bloc = OnboardingBloc(
      config: config,
      userRepository: userRepository,
      authRepository: authRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('OnboardingBloc', () {
    test('initial state is OnboardingInitial', () {
      expect(bloc.state, const OnboardingInitial());
    });

    blocTest<OnboardingBloc, OnboardingState>(
      'emits [OnboardingInProgress] when page changes to non-final page',
      build: () => bloc,
      act: (bloc) => bloc.add(const OnboardingPageChanged(1)),
      expect: () => [const OnboardingInProgress(currentPage: 1)],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'emits [OnboardingCompleted] when page changes to final page',
      build: () => bloc,
      act: (bloc) => bloc.add(OnboardingPageChanged(config.pages.length - 1)),
      expect: () => [const OnboardingCompleted()],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'emits [OnboardingCompleted] when completion is requested',
      build: () => bloc,
      act: (bloc) => bloc.add(OnboardingCompleteRequested()),
      expect: () => [const OnboardingCompleted()],
      verify: (_) {
        verify(() => userRepository.updateUser(any())).called(1);
      },
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'emits [OnboardingError, previousState] when completion fails',
      build: () {
        when(() => userRepository.updateUser(any()))
            .thenThrow(Exception('Update failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(OnboardingCompleteRequested()),
      expect: () => [
        isA<OnboardingError>(),
        const OnboardingInitial(),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'emits [OnboardingCompleted] when skipped and canSkip is true',
      build: () => bloc,
      act: (bloc) => bloc.add(OnboardingSkipped()),
      expect: () => [const OnboardingCompleted()],
      verify: (_) {
        verify(() => userRepository.updateUser(any())).called(1);
      },
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'does not emit when skipped and canSkip is false',
      build: () {
        return OnboardingBloc(
          config: config.copyWith(canSkip: false),
          userRepository: userRepository,
          authRepository: authRepository,
        );
      },
      act: (bloc) => bloc.add(OnboardingSkipped()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => userRepository.updateUser(any()));
      },
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'emits [OnboardingError, previousState] when skip fails',
      build: () {
        when(() => userRepository.updateUser(any()))
            .thenThrow(Exception('Skip failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(OnboardingSkipped()),
      expect: () => [
        isA<OnboardingError>(),
        const OnboardingInitial(),
      ],
    );
  });
}
