import 'package:analytics/analytics.dart';
import 'package:arch_template/core/navigation/navigation.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:user_repository/user_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._authRepository,
    this._userRepository,
    this._appNavigation,
    this._analytics,
  ) : super(AuthInitial()) {
    on<CheckAuthStateChanges>(_onCheckAuthStateChanges);

    add(const CheckAuthStateChanges());
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final AppNavigation _appNavigation;
  final Analytics _analytics;

  // TODO(acrutchfield): Move navigation into the view layer
  Future<void> _onCheckAuthStateChanges(
    CheckAuthStateChanges event,
    Emitter<AuthState> emit,
  ) async {
    await emit.onEach(
      _authRepository.authStateChanges(),
      onData: (currentUser) async {
        if (currentUser == null) {
          await _handleUnauthenticatedUser();
        } else {
          await _handleAuthenticatedUser(
            authUser: currentUser,
            emit: emit,
          );
        }
      },
      onError: (e, s) => _handleError(e, s, emit),
    );
  }

  Future<void> _handleAuthenticatedUser({
    required AuthUser authUser,
    required Emitter<AuthState> emit,
  }) async {
    try {
      _analytics
        ..identifyUser(authUser.id)
        ..trackEvent('login');

      UserEntity? user;
      try {
        user = await _userRepository.getUser(authUser.id);
      } on GetUserException {
        // TODO(acrutchfield): Handle this error more gracefully
        user = authUser.toUserEntity();
        await _userRepository.createUser(user);
      }

      final route = user.isOnboardComplete ? '/' : '/onboarding';
      _appNavigation.replaceNamed(route);
    } catch (e, s) {
      _handleError(e, s, emit);
    }
  }

  Future<void> _handleUnauthenticatedUser() async {
    _analytics.trackEvent('logout');
    _appNavigation.replaceNamed('/login');
  }

  void _handleError(
    Object error,
    StackTrace stackTrace,
    Emitter<AuthState> emit,
  ) {
    _appNavigation.replaceNamed('/login');
    emit(AuthFailure(error.toString()));
    addError(error, stackTrace);
  }
}

extension AuthUserX on AuthUser {
  UserEntity toUserEntity() => UserEntity(
        uid: id,
        email: email,
        username: name,
        isOnboardComplete: false,
      );
}
