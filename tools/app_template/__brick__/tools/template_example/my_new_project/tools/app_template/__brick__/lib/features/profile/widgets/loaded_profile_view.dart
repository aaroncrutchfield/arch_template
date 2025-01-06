import 'package:/features/profile/models/user.dart';
import 'package:/l10n/l10n.dart';
import 'package:flutter/material.dart';

class LoadedProfileView extends StatelessWidget {
  const LoadedProfileView({
    required this.user,
    required this.onEditProfile,
    required this.onSettings,
    super.key,
  });

  final User user;
  final VoidCallback onEditProfile;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 54,
          backgroundImage: NetworkImage(user.photoUrl),
          onBackgroundImageError: (_, __) {},
          child: user.photoUrl.isEmpty
              ? Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: Theme.of(context).textTheme.headlineMedium,
                )
              : null,
        ),
        const SizedBox(height: 24),
        Text(
          user.name.isNotEmpty ? user.name : l10n.noNameProvided,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        const SizedBox(height: 32),
        const Divider(indent: 16, endIndent: 16),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: const Icon(Icons.edit),
          title: Text(l10n.editProfile),
          onTap: onEditProfile,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: const Icon(Icons.settings),
          title: Text(l10n.settings),
          onTap: onSettings,
        ),
      ],
    );
  }
}
