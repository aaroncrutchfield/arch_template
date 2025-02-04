part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class SignedOut extends AuthState {}

final class AuthFailure extends AuthState {
  const AuthFailure(this.error);

  final String error;
}
