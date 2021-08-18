

import 'package:architecture/modules/architecture/domain/entities/post.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/domain/repositories/post_repository.dart';
import 'package:architecture/modules/architecture/domain/usercases/impl/post_usercase_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class PostRepositoryMock extends Mock implements PostRepository {}
main() {

  final repository = PostRepositoryMock();

  final usercase = PostUsercaseImpl(repository);

  test("Deve retornar uma lista de Posts", () async {
    when(repository.call(any))
        .thenAnswer((_) async => Right(<Post>[]));

    final result = await usercase(1);

    expect(result, isA<Right>());
    expect(result | null, isA<List<Post>>());
  });

  test("Deve retornar uma exception caso o valor seja inválido", () async {
    when(repository.call(any))
        .thenAnswer((_) async => Left(ApiException()));

    final result = await usercase(1);

    expect(result.fold(id, id), isA<ApiException>());
  });
}