

import 'dart:convert';

import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/external/datasource/post_datasource_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mok/post_mock.dart';

class DioMock extends Mock implements Dio {}
main() {

  final dio = DioMock();

  final datasource = PostDatasourceImpl(dio);

  test("Deve retornar uma lista de PostModel", () async {

    when(dio.get(any))
        .thenAnswer((_) async => Response(data: jsonDecode(PostResult), statusCode: 200, requestOptions: null));

    expect(datasource.call(1), completes);
  });  


  test("Deve retornar um DioError se ocorrer alguma exceção na consulta", () async {

    when(dio.get(any))
        .thenAnswer((_) async => Response(data: null, statusCode: 401, requestOptions: null));

    expect(datasource.call(1), throwsA(isA<ApiException>()));
  });
}