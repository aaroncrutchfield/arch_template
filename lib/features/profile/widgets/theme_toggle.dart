import 'package:arch_template/features/theme/bloc/theme_bloc.dart';
import 'package:arch_template/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final l10n = context.l10n;
        final isLoaded = state is ThemeLoaded;
        final bloc = context.read<ThemeBloc>();

        return SwitchListTile(
          title: Text(l10n.darkMode),
          value: isLoaded && state.isDarkMode,
          onChanged: isLoaded
              ? (isDark) => bloc.add(ToggleTheme(isDarkMode: isDark))
              : null,
        );
      },
    );
  }
}
