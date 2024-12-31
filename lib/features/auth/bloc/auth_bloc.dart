import 'package:arch_template/core/navigation/navigation.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._authRepository,
    this._appNavigation,
  ) : super(AuthInitial()) {
    on<CheckAuthStateChanges>(_onCheckAuthStateChanges);

    add(const CheckAuthStateChanges());
  }

  final AuthRepository _authRepository;
  final AppNavigation _appNavigation;

  Future<void> _onCheckAuthStateChanges(
    CheckAuthStateChanges event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await emit.onEach(
        _authRepository.authStateChanges(),
        onData: (currentUser) {
          if (currentUser != null) {
            _appNavigation.replaceNamed('/counter');
          } else {
            _appNavigation.replaceNamed('/login');
          }
        },
        onError: (e, s) {
          _appNavigation.replaceNamed('/login');
          emit(AuthFailure(e.toString()));
          addError(e, s);
        },
      );
    } catch (e, s) {
      _appNavigation.replaceNamed('/login');
      emit(AuthFailure(e.toString()));
      addError(e, s);
    }
  }
}
