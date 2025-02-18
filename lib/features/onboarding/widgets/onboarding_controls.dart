import 'package:arch_template/l10n/l10n.dart';
import 'package:flutter/material.dart';

class OnboardingControls extends StatelessWidget {
  const OnboardingControls({
    required this.canSkip,
    required this.isCompleted,
    required this.onSkip,
    required this.onNext,
    required this.onComplete,
    super.key,
  });

  final bool canSkip;
  final bool isCompleted;
  final void Function() onSkip;
  final void Function() onNext;
  final void Function() onComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (canSkip && !isCompleted)
            TextButton(
              onPressed: onSkip,
              child: Text(l10n.skip),
            )
          else
            const SizedBox.shrink(),
          ElevatedButton(
            onPressed: () {
              if (isCompleted) {
                onComplete();
              } else {
                onNext();
              }
            },
            child: Text(
              isCompleted ? l10n.getStarted : l10n.next,
            ),
          ),
        ],
      ),
    );
  }
}
