import 'package:auth_repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.email,
    required this.name,
    required this.photoUrl,
  });

  factory User.fromAuthUser(AuthUser user) {
    return User(
      email: user.email,
      name: user.name,
      photoUrl: user.photoUrl,
    );
  }

  final String email;
  final String name;
  final String photoUrl;

  @override
  List<Object> get props => [email, name, photoUrl];
}
