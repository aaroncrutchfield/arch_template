import 'package:arch_template/core/di/app_registry.dart';
import 'package:arch_template/features/common/widgets/widgets.dart';
import 'package:arch_template/features/profile/bloc/profile_bloc.dart';
import 'package:arch_template/features/profile/widgets/widgets.dart';
import 'package:arch_template/l10n/l10n.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appRegistry.get<ProfileBloc>(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProfileBloc>();
    final l10n = context.l10n;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.profile),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => bloc.add(const ProfileSignOutRequested()),
              ),
            ],
          ),
          body: switch (state) {
            ProfileInitial() || ProfileLoading() => const LoadingIndicator(),
            ProfileError(:final message) => ProfileErrorView(message: message),
            ProfileLoaded(:final user) => LoadedProfileView(
              user: user,
              onEditProfile: () => bloc.add(const ProfileEditRequested()),
              onSettings: () => bloc.add(const ProfileSettingsRequested()),
            ),
          },
        );
      },
    );
  }
}
