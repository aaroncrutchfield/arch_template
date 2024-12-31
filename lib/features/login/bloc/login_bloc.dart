import 'package:arch_template/l10n/arb/app_localizations.dart';
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
    @factoryParam AppLocalizations l10n,
  ) : super(LoginInitial()) {
    _l10n = l10n;
    on<SignInWithGooglePressed>(_onSignInWithGooglePressed);
    on<SignInWithApplePressed>(_onSignInWithApplePressed);
  }

  final AuthRepository _authRepository;
  late final AppLocalizations _l10n;

  Future<void> _onSignInWithGooglePressed(
    SignInWithGooglePressed event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginLoading());
      await _authRepository.signInWithGoogle();
      emit(LoginSuccess());
    } catch (e, s) {
      emit(LoginFailure(_l10n.signInWithGoogleFailed));
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
      emit(LoginFailure(_l10n.signInWithAppleFailed));
      addError(e, s);
    }
  }
}
