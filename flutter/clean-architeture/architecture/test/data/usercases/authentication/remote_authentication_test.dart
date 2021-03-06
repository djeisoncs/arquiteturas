import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/domain/usecases/usercases.dart';

import 'package:architecture/data/usecases/usecases.dart';
import 'package:architecture/data/http/http.dart';

import '../../../mocks/mocks.dart';

class HttpClientMock extends Mock implements HttpClient {}

main() {
  RemoteAuthentication sut;
  HttpClientMock httpClient;
  String url;
  Map apiResult;
  AuthenticationParams params;

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpData(Map data) {
    apiResult = data;
    mockRequest().thenAnswer((_) async => apiResult);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    httpClient = HttpClientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = FakeParamsFactory.makeAuthentication();
    mockHttpData(FackeAccountFactory.makeApiJson());
  });

  test("Should call HttpClient with correct method", () async {
    await sut.auth(params);

    verify(httpClient.request(
        url: url,
        method: "post",
        body: {"email": params.email, "password": params.password}));
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    mockHttpError(HttpError.badRequest);

    expect(sut.auth(params), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    mockHttpError(HttpError.notFound);

    expect(sut.auth(params), throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCre if HttpClient returns 500", () async {
    mockHttpError(HttpError.serverError);

    expect(sut.auth(params), throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCredentials if HttpClient returns 401", () async {
    mockHttpError(HttpError.unauthorized);

    expect(sut.auth(params), throwsA(DomainError.invalidCredentials));
  });

  test("Should an Account if HttpClient returns 200", () async {
    final account = await sut.auth(params);

    expect(account.token, apiResult['accessToken']);
  });

  test("Should throw Unexpected if HttpClient returns 200 with invalid data",
      () async {
    mockHttpData({"invalid_key": "invalid_value"});

    expect(sut.auth(params), throwsA(DomainError.unexpected));
  });
}
