import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/domain/usecases/usercases.dart';

import 'package:architecture/data/usecases/usecases.dart';
import 'package:architecture/data/http/http.dart';

class HttpClientMock extends Mock implements HttpClient {}

main() {
  RemoteAddAccount sut;
  HttpClientMock httpClient;
  String url;
  AddAccountParams params;

  Map mockValidData() =>
      {"accessToken": faker.guid.guid(), "name": faker.person.name()};

  PostExpectation mockRequest() =>
      when(httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    httpClient = HttpClientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
        name: faker.person.name(),
        email: faker.internet.email(),
        password: faker.internet.password(),
        passwordConfirmation: faker.internet.password()
    );
    mockHttpData(mockValidData());
  });

  test("Should call HttpClient with correct method", () async {
    await sut.add(params);

    verify(httpClient.request(
        url: url,
        method: "post",
        body: {
          "name": params.name,
          "email": params.email,
          "password": params.password,
          "passwordConfirmation": params.passwordConfirmation
        })
    );
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    mockHttpError(HttpError.badRequest);

    expect(sut.add(params), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    mockHttpError(HttpError.notFound);

    expect(sut.add(params), throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCre if HttpClient returns 500", () async {
    mockHttpError(HttpError.serverError);

    expect(sut.add(params), throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCredentials if HttpClient returns 403", () async {
    mockHttpError(HttpError.forbidden);

    expect(sut.add(params), throwsA(DomainError.emailInUse));
  });
}