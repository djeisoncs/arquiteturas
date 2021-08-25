

import 'dart:convert';

import 'package:architecture/modules/architecture/data/model/post_model.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:architecture/modules/architecture/external/datasource/post_datasource_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../mok/post_mock.dart';

main() {

  CustomDio dio;
  DioAdapter dioAdapter;
  PostDatasourceImpl datasource;

  group("Grupo responsável por realizar testes da camada de comunicação com Apis externas", () {
    const baseUrl = 'https://example.com';
    const pathGet = "/posts/1/comments";
    const pathGetError = "/posts/0/comments";

    setUp(() {
      dio = CustomDio();
      dio.options = BaseOptions(baseUrl: baseUrl);

      datasource = PostDatasourceImpl(dio);
      dioAdapter = DioAdapter(dio: dio);
    });

    test("Deve realizar metodos referente as chamadas do metodo call", () async {
      dioAdapter
        ..onGet(
            pathGetError,
            (server) => server.throws(
              401,
              DioError(
                requestOptions: RequestOptions(
                  path: pathGetError,
                ),
              ),
            )
        )
        ..onGet(
            pathGet,
            (server) => server.reply(200, jsonDecode(PostResultList))
        );

      expect(datasource.call("0"), throwsA(isA<DioError>()),);

      final result = await datasource.call("1");

      expect(result, isA<List<PostModel>>());
    });

    test("Testar Metodo Post", () async {
      final entidade = PostModel(userId: 1, title: "Teste", body: "Testando metodo post");
      dioAdapter.onPost("/posts",
              (server) => server.reply(200, jsonDecode(PostResult)),
          data: entidade.toJson()
      );

      final result = await datasource.create(entidade);

      expect(result, isA<PostModel>());
    });

  });
}