import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/domain/usecases/usercases.dart';

import 'package:architecture/data/usecases/usecases.dart';
import 'package:architecture/data/http/http.dart';

import '../../../domain/mocks/params_factory.dart';
import '../../../infra/mocks/api_factory.dart';
import '../../mocks/http_client_spy.dart';

main() {
  late RemoteAddAccount sut;
  late HttpClientSpy httpClient;
  late String url;
  late AddAccountParams params;
  late Map apiResult;

  setUp(() {
    httpClient = HttpClientSpy();
    apiResult = ApiFactory.makeAccountJson();
    url = faker.internet.httpUrl();

    httpClient.mockRequest(apiResult);
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = ParamsFactory.makeAddAccount();
  });

  test("Should call HttpClient with correct method", () async {
    await sut.add(params);

    verify(() => httpClient.request(url: url, method: "post", body: {
      "name": params.name,
      "email": params.email,
      "password": params.password,
      "passwordConfirmation": params.passwordConfirmation
    }));
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    httpClient.mockRequestError(HttpError.badRequest);

    expect(sut.add(params), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    httpClient.mockRequestError(HttpError.notFound);

    expect(sut.add(params), throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCre if HttpClient returns 500", () async {
    httpClient.mockRequestError(HttpError.serverError);

    expect(sut.add(params), throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCredentials if HttpClient returns 403", () async {
    httpClient.mockRequestError(HttpError.forbidden);

    expect(sut.add(params), throwsA(DomainError.emailInUse));
  });

  test("Should an Account if HttpClient returns 200", () async {
    final account = await sut.add(params);

    expect(account.token, apiResult['accessToken']);
  });

  test("Should throw Unexpected if HttpClient returns 200 with invalid data", () async {
    httpClient.mockRequest(ApiFactory.makeInvalidJson());

    expect(sut.add(params), throwsA(DomainError.unexpected));
  });
}
