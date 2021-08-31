part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

// ignore: must_be_immutable
class AuthSiginEvent extends AuthEvent {
  final String username;
  final String password;

  AuthSiginEvent(this.username, this.password);

  @override
  List<Object> get props => [username, password];

}
// ignore: must_be_immutable
class AuthLogoutEvent extends AuthEvent {
  final Usuario usuario;

  AuthLogoutEvent(this.usuario);

  @override
  List<Object> get props => [usuario];

}