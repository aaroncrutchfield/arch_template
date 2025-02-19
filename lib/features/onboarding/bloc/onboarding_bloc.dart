import 'package:arch_template/features/onboarding/models/models.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:user_repository/user_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required this.config,
    required this.userRepository,
    required this.authRepository,
  }) : super(const OnboardingInitial()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingCompleteRequested>(_onCompleteRequested);
    on<OnboardingSkipped>(_onSkipped);
  }

  final OnboardingConfig config;
  final UserRepository userRepository;
  final AuthRepository authRepository;

  Future<void> _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) async {
    if (event.pageIndex == config.pages.length) {
      emit(const OnboardingCompleted());
    } else {
      emit(OnboardingInProgress(currentPage: event.pageIndex));
    }
  }

  Future<void> _onCompleteRequested(
    OnboardingCompleteRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      final authUser = authRepository.currentUser;
      final user = await userRepository.getUser(authUser.id);
      await userRepository.updateUser(
        user.copyWith(isOnboardComplete: true),
      );
      emit(const OnboardingCompleted());
    } catch (e, s) {
      addError(e, s);
      emit(OnboardingError(message: e.toString()));
      // Revert to previous state after error
      emit(state);
    }
  }

  Future<void> _onSkipped(
    OnboardingSkipped event,
    Emitter<OnboardingState> emit,
  ) async {
    if (config.canSkip) {
      try {
        final authUser = authRepository.currentUser;
        final user = await userRepository.getUser(authUser.id);
        await userRepository.updateUser(
          user.copyWith(isOnboardComplete: true),
        );
        emit(const OnboardingCompleted());
      } catch (e, s) {
        addError(e, s);
        emit(OnboardingError(message: e.toString()));
        // Revert to previous state after error
        emit(state);
      }
    }
  }
}
