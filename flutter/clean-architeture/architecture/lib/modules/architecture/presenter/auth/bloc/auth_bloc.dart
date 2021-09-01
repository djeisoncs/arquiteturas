import 'dart:async';

import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/domain/usercases/auth_usercase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthUsercase usercase;


  AuthBloc(this.usercase) : super(AuthInitialState());

  AuthState get initialState => AuthLoadingState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield AuthLoadingState();

    if (event is AuthSiginEvent) {
      yield* _mapAuthLoadingToState(event);
    } else if (event is AuthLogoutEvent) {
      _mapAuthLogoutToState();
    }
  }

  Stream<AuthState> _mapAuthLoadingToState(AuthSiginEvent event) async* {
    final result = await usercase.signIn(event.username, event.password);
    yield result.fold((l) => AuthErrorState(l), (r) => AuthSucessState(r));
  }

  void _mapAuthLogoutToState() {
    /**
     * TODO implementar o logout do sistema
     */
  }
}
