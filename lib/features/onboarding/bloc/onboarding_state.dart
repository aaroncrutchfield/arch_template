part of 'onboarding_bloc.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState({
    required this.currentPage,
    required this.isCompleted,
  });

  final int currentPage;
  final bool isCompleted;

  @override
  List<Object?> get props => [currentPage, isCompleted];
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial() : super(currentPage: 0, isCompleted: false);
}

final class OnboardingInProgress extends OnboardingState {
  const OnboardingInProgress({required super.currentPage})
      : super(isCompleted: false);
}

final class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted() : super(currentPage: -1, isCompleted: true);
}

final class OnboardingError extends OnboardingState {
  const OnboardingError({
    required this.message,
  }) : super(currentPage: -1, isCompleted: false);

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}
