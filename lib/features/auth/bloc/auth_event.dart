part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStateChanges extends AuthEvent {
  const CheckAuthStateChanges();
}
