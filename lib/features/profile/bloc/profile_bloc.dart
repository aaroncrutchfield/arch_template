import 'package:arch_template/features/profile/models/user.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._authRepository) : super(ProfileInitial()) {
    on<ProfileStarted>(_onProfileStarted);
    on<ProfileSignOutRequested>(_onProfileSignOutRequested);
    on<ProfileEditRequested>(_onProfileEditRequested);
    on<ProfileSettingsRequested>(_onProfileSettingsRequested);

    add(const ProfileStarted());
  }

  final AuthRepository _authRepository;

  Future<void> _onProfileStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final user = await _authRepository.authStateChanges().first.then(
            (user) => user != null ? User.fromAuthUser(user) : null,
          );

      if (user != null) {
        emit(ProfileLoaded(user: user));
      } else {
        emit(const ProfileError(message: 'User not found'));
      }
    } catch (e, s) {
      addError(e, s);
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onProfileSignOutRequested(
    ProfileSignOutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _authRepository.signOut();
    } catch (e, s) {
      addError(e, s);
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onProfileEditRequested(
    ProfileEditRequested event,
    Emitter<ProfileState> emit,
  ) async {}

  Future<void> _onProfileSettingsRequested(
    ProfileSettingsRequested event,
    Emitter<ProfileState> emit,
  ) async {}
}
