import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/domain/usecases/usercases.dart';

import 'package:architecture/data/usecases/usecases.dart';
import 'package:architecture/data/http/http.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/api_factory.dart';
import '../../mocks/http_client_spy.dart';

main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late Map apiResult;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    apiResult = ApiFactory.makeAccountJson();
    httpClient.mockRequest(apiResult);
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = ParamsFactory.makeAuthentication();
  });

  test("Should call HttpClient with correct method", () async {
    await sut.auth(params);

    verify(() => httpClient.request(
        url: url,
        method: "post",
        body: {"email": params.email, "password": params.password}));
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    httpClient.mockRequestError(HttpError.badRequest);

    expect(sut.auth(params), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    httpClient.mockRequestError(HttpError.notFound);

    expect(sut.auth(params), throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCre if HttpClient returns 500", () async {
    httpClient.mockRequestError(HttpError.serverError);

    expect(sut.auth(params), throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCredentials if HttpClient returns 401", () async {
    httpClient.mockRequestError(HttpError.unauthorized);

    expect(sut.auth(params), throwsA(DomainError.invalidCredentials));
  });

  test("Should an Account if HttpClient returns 200", () async {
    final account = await sut.auth(params);

    expect(account.token, apiResult['accessToken']);
  });

  test("Should throw Unexpected if HttpClient returns 200 with invalid data", () async {
    httpClient.mockRequest(ApiFactory.makeInvalidJson());

    expect(sut.auth(params), throwsA(DomainError.unexpected));
  });
}
