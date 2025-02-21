part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

final class LoadTheme extends ThemeEvent {
  const LoadTheme();
}

final class ToggleTheme extends ThemeEvent {
  final bool isDarkMode;

  const ToggleTheme({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}
