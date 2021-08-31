part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitialState extends AuthState {
  const AuthInitialState();

  @override
  List<Object> get props => [];
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();

  @override
  List<Object> get props => [];
}

class AuthSucessState extends AuthState {
  final Usuario usuario;

  const AuthSucessState(this.usuario);

  @override
  List<Object> get props => [usuario];
}

class AuthErrorState extends AuthState {
  final AppError appError;

  const AuthErrorState(this.appError);

  @override
  List<Object> get props => [appError];
}
