part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class CheckAuthStateChanges extends AuthEvent {
  const CheckAuthStateChanges();
}
