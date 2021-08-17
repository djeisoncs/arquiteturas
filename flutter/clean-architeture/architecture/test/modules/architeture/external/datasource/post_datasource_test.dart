
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:architecture/modules/architecture/external/datasource/post_datasource_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class CustomDioMock extends Mock implements CustomDio {

}

main() {

  final client = CustomDioMock();
  final datasource = PostDatasourceImpl(client);

  test("Deve retornar uma lista de postModel", () async {
    when(client.get(any)).thenAnswer((_) async => Response(requestOptions: RequestOptions(path: "https://jsonplaceholder.typicode.com")));

    final result = datasource.getPosts();

    expect(result, completes);
  });
}