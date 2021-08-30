
import 'package:architecture/app_module.dart';
import 'package:architecture/init_modular.dart';
import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:architecture/modules/architecture/domain/usercases/auth_usercase.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';

import 'modules/architeture/mok/token_response.dart';

class DioMock extends Mock implements CustomDio {}

main() {

  DioMock dio;
  DioAdapter dioAdapter;

  initModule(AppModule(), replaceBinds: [
    Bind<CustomDio>((i) => dio),
  ]);

  group("Grupo responsável por realizar testes de autenticação na camada external", () {

    setUp(() {
      dio = DioMock();
      dio.options = BaseOptions(baseUrl: "www.exemplo.com");
      dioAdapter = DioAdapter(dio: dio);
    });

    test("Deve retornar o usuário autenticado", () async {
      dioAdapter.onPost("/auth",
              (server) => server.reply(200, tokenResponse));

      final usercase = Modular.get<AuthUsercase>();

      final result = await usercase.auth("username", "password");

      expect(result, isA<Usuario>());
    });

  });
}