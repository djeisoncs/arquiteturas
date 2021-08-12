
import 'dart:convert';

import 'package:architecture/modules/architecture/data/model/usuario_model.dart';
import 'package:architecture/modules/architecture/external/datasource/auth_datasource_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DioMock extends Mock implements HttpClientAdapter {}

main() {
  final dioAdapterMock = DioMock();
  final dio = Dio();

  final datasource = AuthDatasourceImpl(dio);

  test("Deve retornar um usuário autenticado", () async {
    final responsepayload = jsonEncode({"response_code": "1000"});
    final httpResponse =
    ResponseBody.fromString(responsepayload, 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType]
    });

    when(dioAdapterMock.fetch(any, any, any))
        .thenAnswer((_) async => httpResponse);

    final result = await datasource.auth("username", "password");

    expect(result, completes);
  });
}