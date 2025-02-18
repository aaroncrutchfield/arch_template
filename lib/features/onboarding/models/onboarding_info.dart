import 'package:flutter/animation.dart';

class OnboardingInfo {
  const OnboardingInfo({
    required this.title,
    required this.description,
    this.imagePath,
    this.customData,
  });

  final String title;
  final String description;
  final String? imagePath;
  final Map<String, dynamic>? customData;
}

class OnboardingConfig {
  const OnboardingConfig({
    required this.pages,
    this.canSkip = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.transitionCurve = Curves.easeInOut,
  });

  final List<OnboardingInfo> pages;
  final bool canSkip;
  final Duration transitionDuration;
  final Curve transitionCurve;
}
