import 'package:auth_repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:user_repository/user_repository.dart';

part 'theme_event.dart';
part 'theme_state.dart';

/// Manages the application theme state
@injectable
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(
    this._userRepository,
    this._authRepository,
  ) : super(const ThemeInitial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);

    add(const LoadTheme());
  }

  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    try {
      final uid = _authRepository.currentUser.id;
      await emit.forEach(
        _userRepository.userChanges(uid),
        onData: (UserEntity? user) {
          if (user == null) return const ThemeInitial();
          return ThemeLoaded(isDarkMode: user.isDarkMode);
        },
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(const ThemeInitial());
    }
  }

  Future<void> _onToggleTheme(
      ToggleTheme event, Emitter<ThemeState> emit) async {
    if (state is! ThemeLoaded) return;

    try {
      final uid = _authRepository.currentUser.id;
      final user = await _userRepository.getUser(uid);
      await _userRepository.updateUser(
        user.copyWith(isDarkMode: event.isDarkMode),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}
