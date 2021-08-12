import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/domain/repositories/auth_repository.dart';
import 'package:architecture/modules/architecture/domain/usercases/impl/auth_usercase_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

main() {
  final repository = AuthRepositoryMock();

  final usercase = AuthUsercaseImpl(repository);

  test('Deve fazer o login', () async {
    when(repository.auth(any, any))
        .thenAnswer((_) async => Right(Usuario()));

    final result = await usercase.auth("userTest", "passwordTest");

    expect(result, isA<Right>());
    expect(result | null, isA<Usuario>());
    verify(repository.auth("userTest", "passwordTest"));
    verifyNoMoreInteractions(repository);
  });

  test('Deve fazer um exception caso o username seja vazio', () async {
    when(repository.auth(any, any))
        .thenAnswer((_) async => Right(Usuario()));

    final result = await usercase.auth("", "passwordTest");

    expect(result.isLeft(), true);
    expect(result.fold((l) => l, (r) => r), isA<AuthException>());
  });

  test('Deve fazer um exception caso o username seja nulo', () async {
    when(repository.auth(any, any))
        .thenAnswer((_) async => Right(Usuario()));

    final result = await usercase.auth(null, "passwordTest");

    expect(result.fold(id, id), isA<AuthException>());
  });

  test('Deve fazer um exception caso o username e password seja vazio',
      () async {
    when(repository.auth(any, any))
        .thenAnswer((_) async => Right(Usuario()));

    final result = await usercase.auth("", "");

    expect(result.fold(id, id), isA<AuthException>());
  });

  test('Deve fazer um exception caso o username e password seja nulo',
      () async {
    when(repository.auth(any, any))
        .thenAnswer((_) async => Right(Usuario()));

    final result = await usercase.auth(null, null);

    expect(result.fold(id, id), isA<AuthException>());
  });

  test('Deve fazer um exception caso o password seja vazio', () async {
    when(repository.auth(any, any))
        .thenAnswer((_) async => Right(Usuario()));

    final result = await usercase.auth("userTest", "");

    expect(result.fold(id, id), isA<AuthException>());
  });

  test('Deve fazer um exception caso o password seja nulo', () async {
    when(repository.auth(any, any))
        .thenAnswer((_) async => Right(Usuario()));

    final result = await usercase.auth("userTest", null);

    expect(result.fold(id, id), isA<AuthException>());
  });
}
