part of 'theme_bloc.dart';

sealed class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

final class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

final class ThemeLoaded extends ThemeState {

  const ThemeLoaded({required this.isDarkMode});
  
  final bool isDarkMode;

  @override
  List<Object?> get props => [isDarkMode];

  ThemeLoaded copyWith({bool? isDarkMode}) {
    return ThemeLoaded(
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
