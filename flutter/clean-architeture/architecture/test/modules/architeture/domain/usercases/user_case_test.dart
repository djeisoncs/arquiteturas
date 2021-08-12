import 'package:architecture/modules/architecture/domain/entities/entity.dart';
import 'package:architecture/modules/architecture/domain/entities/paginator.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/domain/repositories/repository.dart';
import 'package:architecture/modules/architecture/domain/usercases/impl/usercase_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RepositoryMock extends Mock implements Repository {}

main() {
  final repository = RepositoryMock();

  final usercase = UsercaseIpml(repository);

  final paginator = Paginator();

  test("Deve retornar uma lista de entidade", () async {
    when(repository.call(any)).thenAnswer((_) async => Right(<Entity>[]));

    final result = await usercase(paginator);

    expect(result | null, isA<List<Entity>>());
    verify(repository.call(paginator));
    verifyNoMoreInteractions(repository);
  });

  test("Deve retornar um exception se o paginator for nulo", () async {
    when(repository.call(any)).thenAnswer((_) async => Right(<Entity>[]));

    final result = await usercase(null);

    expect(result.fold(id, id), isA<ApiException>());
  });

  test("Deve retornar uma entidade", () async {
    when(repository.getById(any)).thenAnswer((_) async => Right(Entity()));

    final result = await usercase.getById("UUID");

    expect(result, isA<Right>());
    expect(result | null, isA<Entity>());
    verify(repository.getById("UUID"));
    verifyNoMoreInteractions(repository);
  });

  test("Deve retornar um exception se o id for vazio ou nulo", () async {
    when(repository.getById(any)).thenAnswer((_) async => Right(Entity()));

    final result = await usercase.getById("");

    expect(result.fold(id, id), isA<ApiException>());
  });

  test("Deve retornar um exception se o id for nulo", () async {
    when(repository.getById(any)).thenAnswer((_) async => Right(Entity()));

    final result = await usercase.getById(null);

    expect(result.fold(id, id), isA<ApiException>());
  });

  test("Deve salvar uma entidade", () async {
    when(repository.save(any)).thenAnswer((_) async => Right(Entity()));

    Entity entity = Entity();

    final result = await usercase.save(entity);

    expect(result, isA<Right>());
    expect(result | null, isA<Entity>());
    verify(repository.save(entity));
    verifyNoMoreInteractions(repository);
  });

  test("Deve editar uma entidade", () async {
    when(repository.edit(any)).thenAnswer((_) async => Right(Entity()));

    Entity entity = Entity(id: "UUID");

    final result = await usercase.save(entity);

    expect(result, isA<Right>());
    expect(result | null, isA<Entity>());
    verify(repository.edit(entity));
    verifyNoMoreInteractions(repository);
  });

  test("Deve retornar um exception se a entidade for nula", () async {
    when(repository.save(any)).thenAnswer((_) async => Right(Entity()));

    final result = await usercase.save(null);

    expect(result.fold(id, id), isA<ApiException>());
  });

  test("Deve excluir uma entidade", () async {
    when(repository.delete(any)).thenAnswer((_) async => Right(null));

    Entity entity = Entity(id: "UUID");

    final result = await usercase.delete(entity);

    expect(result, isA<Right>());
    expect(result, isA<void>());
    verify(repository.delete(entity));
    verifyNoMoreInteractions(repository);
  });

  test("Deve tentar excluir uma entity retornar um exception se a entidade for nula", () async {
    when(repository.delete(any)).thenAnswer((_) async => Right(null));

    final result = await usercase.delete(null);

    expect(result, isA<Left>());
  });
}
