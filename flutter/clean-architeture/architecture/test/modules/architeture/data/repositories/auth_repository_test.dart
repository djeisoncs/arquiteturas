
import 'package:architecture/modules/architecture/data/datasources/auth_datasource.dart';
import 'package:architecture/modules/architecture/data/model/usuario_model.dart';
import 'package:architecture/modules/architecture/data/repositories/auth_repository_impl.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class AuthDatasourceMock extends Mock implements AuthDatasource {}

main() {

  AuthDatasourceMock datasource;

  AuthRepositoryImpl repository;

  group("Grupo para realizar testes referente a autenticação", () {

    setUp(() {
      datasource = AuthDatasourceMock();
      repository = AuthRepositoryImpl(datasource);
    });

    test("Deve retornar um token de autenticação", () async {
      when(datasource.auth(any, any)).thenAnswer((_) async => UsuarioModel());

      final result = await repository.auth("userTest", "passwordTest");

      expect(result | null, isA<UsuarioModel>());
    });

    test("Deve retornar uma exception se o datasource falhar", () async {
      when(datasource.auth(any, any)).thenThrow(Exception());

      final result = await repository.auth("userTest", "passwordTest");

      expect(result.fold(id, id), isA<AppError>());
    });

  });
}