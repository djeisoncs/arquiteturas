import 'package:architecture/modules/architecture/domain/entities/post.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/domain/usercases/post_usercase.dart';
import 'package:architecture/modules/architecture/presenter/post/post_bloc.dart';
import 'package:architecture/modules/architecture/presenter/post/states/post_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class PostUsercaseMock extends Mock implements PostUsercase {}

main() {
  final usercase = PostUsercaseMock();
  final bloc = PostBloc(usercase);

  test("Deve retornar os estados na ordem correta", () {
    when(usercase.call(any)).thenAnswer((_) async => Right(<Post>[]));

    expect(bloc,
      emitsInOrder([
        isA<PostStateLoading>(),
        isA<PostStateSuccess>()
      ])
    );

    bloc.add("1");
  });

  test("Deve retornar um erro", () {
    when(usercase.call(any)).thenAnswer((_) async => Left(ApiException()));

    expect(bloc,
      emitsInOrder([
        isA<PostStateLoading>(),
        isA<PostStateError>()
      ])
    );

    bloc.add("1");
  });
}
