

import 'package:architecture/modules/architecture/data/datasources/post_datasource.dart';
import 'package:architecture/modules/architecture/data/model/post_model.dart';
import 'package:architecture/modules/architecture/data/repositories/post_repository.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class PostDatasourceMock extends Mock implements PostDatasource {}
main() {

  final datasource = PostDatasourceMock();

  final repository = PostRepositoryImpl(datasource);

  test("Deve retornar um datasource", () async {

    when(datasource.call(any))
        .thenAnswer((_) async => <PostModel>[]);

    final result = await repository.call(1);

    expect(result | null, isA<List<PostModel>>());
  });

  test("Deve retornar um erro se o datasource falhar", () async {

    when(datasource.call(any))
        .thenThrow(ApiException());

    final result = await repository.call(1);

    expect(result.fold(id, id), isA<ApiException>());
  });
}