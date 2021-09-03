import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/domain/usecases/usercases.dart';

import 'package:architecture/data/usecases/usecases.dart';
import 'package:architecture/data/http/http.dart';

class HttpClientMock extends Mock implements HttpClient {}

main() {
  RemoteAuthentication sut;
  HttpClientMock httpClient;
  String url;
  AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());
  });

  test("Should call HttpClient with correct method", () async {
    await sut.auth(params);

    verify(httpClient.request(
        url: url,
        method: "post",
        body: {"email": params.email, "password": params.password}
    ));

  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    when(httpClient.request(url: anyNamed("url"), method: anyNamed("method"), body: anyNamed("body")))
        .thenThrow(HttpError.badRequest);

    expect(sut.auth(params), throwsA(DomainError.unexpected));

  });
}