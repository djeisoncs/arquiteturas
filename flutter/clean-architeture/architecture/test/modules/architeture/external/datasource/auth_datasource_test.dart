import 'package:architecture/modules/architecture/data/model/usuario_model.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:architecture/modules/architecture/external/datasource/auth_datasource_impl.dart';
import 'package:architecture/modules/architecture/constantes/api_path.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../mok/token_response.dart';

main() {
  CustomDio dio;
  DioAdapter dioAdapter;
  AuthDatasourceImpl datasource;

  group(
      "Grupo responsável por realizar testes de autenticação na camada external",
      () {
    String path = "/auth";

    setUp(() {
      dio = CustomDio();
      dio.options = BaseOptions(baseUrl: ApiPath.API_BASE_URL);
      datasource = AuthDatasourceImpl(dio);
      dioAdapter = DioAdapter(dio: dio);
    });

    test("Deve retornar o usuário autenticado", () async {
      dioAdapter.onPost(path, (server) => server.reply(200, tokenResponse));

      final result = await datasource.auth("username", "password");

      expect(result, isA<UsuarioModel>());
    });

    test("Deve retornar um DioErro 400", () async {
      dioAdapter.onPost(
          path,
          (server) => server.throws(
                400,
                DioError(
                  requestOptions: RequestOptions(
                    path: path,
                  ),
                ),
              ));

      expect(datasource.auth("username", "password"), throwsA(isA<DioError>()));
    });

    test("Deve retornar um DioErro 404", () async {
      dioAdapter.onPost(
          path,
          (server) => server.throws(
                404,
                DioError(
                  requestOptions: RequestOptions(
                    path: path,
                  ),
                ),
              ));

      expect(datasource.auth("username", "password"), throwsA(isA<DioError>()));
    });

    test("Deve retornar um DioErro 500", () async {
      dioAdapter.onPost(
          path,
          (server) => server.throws(
                500,
                DioError(
                  requestOptions: RequestOptions(
                    path: path,
                  ),
                ),
              ));

      expect(datasource.auth("username", "password"), throwsA(isA<DioError>()));
    });

    test("Deve retornar um DioErro 403", () async {
      dioAdapter.onPost(
          path,
          (server) => server.throws(
                403,
                DioError(
                  requestOptions: RequestOptions(
                    path: path,
                  ),
                ),
              ));

      expect(datasource.auth("username", "password"), throwsA(isA<DioError>()));
    });

  });
}
