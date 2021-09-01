

import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/domain/usercases/auth_usercase.dart';
import 'package:architecture/modules/architecture/presenter/auth/bloc/auth_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class AuthUsercaseMock extends Mock implements AuthUsercase {}

main() {

  AuthUsercaseMock usercase;
  AuthBloc bloc;

  setUp(() {
    usercase = AuthUsercaseMock();
    bloc = AuthBloc(usercase);
  });

  test("Deve retornar os estados da autenticação na ordem correta", () {
    final event = AuthSiginEvent("username", "password");
    when(usercase.signIn(any, any)).thenAnswer((_) async => Right(Usuario()));

    expect(bloc,
      emitsInOrder([
        isA<AuthLoadingState>(),
        isA<AuthSucessState>(),
      ])
    );

    bloc.add(event);
  });

  test("Deve retornar um erro na autenticação", () {
    final event = AuthSiginEvent("", "");
    when(usercase.signIn(any, any)).thenAnswer((_) async => Left(AppError()));

    expect(bloc,
        emitsInOrder([
          isA<AuthLoadingState>(),
          isA<AuthErrorState>()
        ])
    );

    bloc.add(event);
  });
}