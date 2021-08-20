

import 'dart:convert';

import 'package:architecture/app_module.dart';
import 'package:architecture/init_modular.dart';
import 'package:architecture/modules/architecture/data/datasources/post_datasource.dart';
import 'package:architecture/modules/architecture/domain/entities/post.dart';
import 'package:architecture/modules/architecture/domain/usercases/impl/post_usercase_impl.dart';
import 'package:architecture/modules/architecture/domain/usercases/post_usercase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'modules/architeture/mok/post_mock.dart';

class DioMock extends Mock implements Dio {}
main() {

  final dio = DioMock();

  initModule(AppModule(), replaceBinds: [
    Bind<Dio>((i) => dio),
  ]);

  test("Deve recuperar o usercase sem erro", () {
    final usercase = Modular.get<PostUsercase>();

    expect(usercase, isA<PostUsercaseImpl>());
  });

  test("Deve recuperar uma lista de Post", () async {
    when(dio.get(any))
        .thenAnswer((_) async => Response(data: jsonDecode(PostResult), statusCode: 200, requestOptions: null));

    final usercase = Modular.get<PostDatasource>();

    final result = await usercase("1");

    expect(result , isA<List<Post>>());
  });
}