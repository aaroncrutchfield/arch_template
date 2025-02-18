import 'package:arch_template/core/di/app_registry.dart';
import 'package:arch_template/features/common/extensions/extensions.dart';
import 'package:arch_template/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:arch_template/features/onboarding/models/models.dart';
import 'package:arch_template/features/onboarding/widgets/widgets.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appRegistry.get<OnboardingBloc>(),
      child: OnboardingView(
        config: appRegistry.get<OnboardingConfig>(),
      ),
    );
  }
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({
    required this.config,
    super.key,
  });

  final OnboardingConfig config;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OnboardingBloc>();

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) async {
        if (state is OnboardingCompleted) {
          if (context.mounted) {
            context.navigation.replaceNamed('/counter');
          }
        } else if (state is OnboardingError) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        }
      },
      child: Scaffold(
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return Stack(
              children: [
                PageView.builder(
                  itemCount: config.pages.length,
                  onPageChanged: (index) =>
                      bloc.add(OnboardingPageChanged(index)),
                  itemBuilder: (context, index) => PageContent(
                    page: config.pages[index],
                  ),
                ),
                OnboardingProgress(
                  pageCount: config.pages.length,
                  currentPage: state.currentPage,
                ),
                OnboardingControls(
                  canSkip: config.canSkip,
                  isCompleted: state.isCompleted,
                  onSkip: () => bloc.add(OnboardingSkipped()),
                  onNext: () => bloc.add(OnboardingCompleteRequested()),
                  onComplete: () => bloc.add(OnboardingCompleteRequested()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
