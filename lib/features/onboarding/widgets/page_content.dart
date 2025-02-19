import 'package:arch_template/features/onboarding/models/models.dart';
import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  const PageContent({
    required this.page,
    super.key,
  });

  final OnboardingInfo page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (page.imagePath != null) ...[
            Image.asset(
              page.imagePath!,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 40),
          ],
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
