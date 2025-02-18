// coverage:ignore-file

import 'package:arch_template/features/onboarding/models/models.dart';
import 'package:injectable/injectable.dart';

@module
abstract class OnboardingModule {
  @injectable
  OnboardingConfig get onboardingConfig => const OnboardingConfig(
        pages: [
          OnboardingInfo(
            title: 'Welcome to AppName',
            description: 'Your all-in-one solution for managing daily tasks',
            imagePath: 'assets/images/onboarding/welcome.png',
          ),
          OnboardingInfo(
            title: 'Stay Organized',
            description: 'Keep track of your tasks, events, and deadlines',
            imagePath: 'assets/images/onboarding/organize.png',
          ),
          OnboardingInfo(
            title: 'Sync Across Devices',
            description: 'Access your data from anywhere, anytime',
            imagePath: 'assets/images/onboarding/sync.png',
          ),
        ],
        transitionDuration: Duration(milliseconds: 400),
      );
}
