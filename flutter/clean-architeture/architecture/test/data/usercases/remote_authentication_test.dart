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
    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
  });

  test("Should call HttpClient with correct method", () async {
    when(httpClient.request(
            url: anyNamed("url"),
            method: anyNamed("method"),
            body: anyNamed("body")))
        .thenAnswer((_) async =>
            {"accessToken": faker.guid.guid(), "name": faker.person.name()});

    await sut.auth(params);

    verify(httpClient.request(
        url: url,
        method: "post",
        body: {"email": params.email, "password": params.password}));
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    when(httpClient.request(
            url: anyNamed("url"),
            method: anyNamed("method"),
            body: anyNamed("body")))
        .thenThrow(HttpError.badRequest);

    expect(sut.auth(params), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    when(httpClient.request(
            url: anyNamed("url"),
            method: anyNamed("method"),
            body: anyNamed("body")))
        .thenThrow(HttpError.notFound);

    expect(sut.auth(params), throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCre if HttpClient returns 500", () async {
    when(httpClient.request(
            url: anyNamed("url"),
            method: anyNamed("method"),
            body: anyNamed("body")))
        .thenThrow(HttpError.serverError);

    expect(sut.auth(params), throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCredentials if HttpClient returns 401", () async {
    when(httpClient.request(
            url: anyNamed("url"),
            method: anyNamed("method"),
            body: anyNamed("body")))
        .thenThrow(HttpError.unauthorized);

    expect(sut.auth(params), throwsA(DomainError.invalidCredentials));
  });

  test("Should an Account if HttpClient returns 200", () async {
    final token = faker.guid.guid();

    when(httpClient.request(
            url: anyNamed("url"),
            method: anyNamed("method"),
            body: anyNamed("body")))
        .thenAnswer(
            (_) async => {"accessToken": token, "name": faker.person.name()});

    final account = await sut.auth(params);

    expect(account.token, token);
  });
}
