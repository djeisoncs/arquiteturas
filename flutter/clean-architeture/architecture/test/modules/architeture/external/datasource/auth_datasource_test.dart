
import 'dart:convert';

import 'package:architecture/modules/architecture/data/model/usuario_model.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:architecture/modules/architecture/external/datasource/auth_datasource_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DioMock extends Mock implements CustomDio {}

main() {
  final dioMock = DioMock();

  final datasource = AuthDatasourceImpl(dioMock);

  // test("Deve retornar um usuário autenticado", () async {
  //   final responsepayload = jsonEncode({"response_code": "1000"});
  //   final httpResponse =
  //   ResponseBody.fromString(responsepayload, 200, headers: {
  //     Headers.contentTypeHeader: [Headers.jsonContentType]
  //   });
  //
  //   when(dioAdapterMock.fetch(any, any, any))
  //       .thenAnswer((_) async => httpResponse);
  //
  //   final result = await datasource.auth("username", "password");
  //
  //   expect(result, completes);
  // });

  test("Deve retornar uma lista de postModel", () async {
    when(dioMock.get(any)).thenAnswer((realInvocation) async => Response(requestOptions: RequestOptions(connectTimeout: 5000, contentType: "application/json;charset=UTF-8", path: any), statusCode: 200));

    final result = await datasource.getPosts();

    expect(result, completes);
  });
}