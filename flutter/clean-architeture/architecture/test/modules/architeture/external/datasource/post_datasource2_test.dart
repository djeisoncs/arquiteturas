
import 'dart:convert';

import 'package:architecture/modules/architecture/data/model/post_model.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:architecture/modules/architecture/external/datasource/http_helper.dart';
import 'package:architecture/modules/architecture/external/datasource/post_datasource_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  //test get request
  //test post request
  //test
  final CustomDio tdio = CustomDio();
  DioAdapterMock dioAdapterMock;
  APIHelper tapi;
  PostDatasourceImpl datasource;

  setUp(() {
    dioAdapterMock = DioAdapterMock();
    tdio.httpClientAdapter = dioAdapterMock;
    tapi = APIHelper.test(dio: tdio);
    datasource = PostDatasourceImpl(tdio, apiHelper: tapi);
  });

  group('Get method', () {
    test('canbe used to get responses for any url', () async {
      final responsepayload = jsonEncode({"response_code": "200"});
      final httpResponse = ResponseBody.fromString(
        responsepayload,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final response = await tapi.get("/any url");
      final expected = {"response_code": "200"};

      expect(response, equals(expected));
    });
  });

  group('Post Method', () {
    test('canbe used to get responses for any requests with body', () async {
      final entidade = PostModel(title: "Teste Gabiarra", body: "Fazendo gambiarra");
      final responsepayload = jsonEncode({"response_code": "200"});
      final httpResponse =
      ResponseBody.fromString(responsepayload, 200, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      });

      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      // final response = await tapi.post("/any url", body: {"body": "body"});
      final response = await datasource.create(entidade);
      final expected = {"response_code": "200"};

      expect(response, equals(expected));
    });
  });
}