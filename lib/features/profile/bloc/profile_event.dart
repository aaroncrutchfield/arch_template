part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

final class ProfileSignOutRequested extends ProfileEvent {
  const ProfileSignOutRequested();
}

final class ProfileEditRequested extends ProfileEvent {
  const ProfileEditRequested();
}

final class ProfileSettingsRequested extends ProfileEvent {
  const ProfileSettingsRequested();
}
