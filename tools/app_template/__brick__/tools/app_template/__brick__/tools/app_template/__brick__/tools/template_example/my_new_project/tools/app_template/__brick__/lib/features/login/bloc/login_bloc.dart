import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(
    this._authRepository,
  ) : super(LoginInitial()) {
    on<SignInWithGooglePressed>(_onSignInWithGooglePressed);
    on<SignInWithApplePressed>(_onSignInWithApplePressed);
  }

  final AuthRepository _authRepository;

  Future<void> _onSignInWithGooglePressed(
    SignInWithGooglePressed event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginLoading());
      await _authRepository.signInWithGoogle();
      emit(LoginSuccess());
    } catch (e, s) {
      emit(GoogleLoginFailure());
      addError(e, s);
    }
  }

  Future<void> _onSignInWithApplePressed(
    SignInWithApplePressed event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginLoading());
      await _authRepository.signInWithApple();
      emit(LoginSuccess());
    } catch (e, s) {
      emit(AppleLoginFailure());
      addError(e, s);
    }
  }
}
