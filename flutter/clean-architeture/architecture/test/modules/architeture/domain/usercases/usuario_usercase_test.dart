
import 'package:architecture/modules/architecture/domain/entities/paginator.dart';
import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:architecture/modules/architecture/domain/repositories/usuario_repository.dart';
import 'package:architecture/modules/architecture/domain/usercases/impl/usuario_usercase_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UsuarioRepositoryMock extends Mock implements UsuarioRepository {}

main() {

  final repository = UsuarioRepositoryMock();

  final usercase = UsuarioUsercaseImpl(repository);

  final paginator = Paginator();

  test("Deve retornar uma lista de usuarios", () async {

    when(repository.call(any)).thenAnswer((_) async => Right(<Usuario>[]));

    final result = await usercase(paginator);

    expect(result | null, isA<List<Usuario>>());
  });
}