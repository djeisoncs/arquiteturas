import 'package:architecture/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:architecture/domain/entities/entities.dart';

import 'package:architecture/data/usecases/usecases.dart';
import 'package:architecture/data/http/http.dart';

import '../../../infra/mocks/api_factory.dart';
import '../../mocks/http_client_spy.dart';

void main() {
  late RemoteLoadSurveys sut;
  late HttpClientSpy httpClient;
  late String url;
  late List<Map> list;

  setUp(() {
    url = faker.internet.httpsUrl();
    list = ApiFactory.makeSurveyList();

    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    httpClient.mockRequest(list);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
        id: list[0]['id'],
        question: list[0]['question'],
        dateTime: DateTime.parse(list[0]['date']),
        didAnswer: list[0]['didAnswer'],
      ),
      SurveyEntity(
        id: list[1]['id'],
        question: list[1]['question'],
        dateTime: DateTime.parse(list[1]['date']),
        didAnswer: list[1]['didAnswer'],
      )
    ]);
  });

  test("Should throw Unexpected if HttpClient returns 200 with invalid data", () async {
    httpClient.mockRequest(ApiFactory.makeInvalidList());

    expect(sut.load(), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    httpClient.mockRequestError(HttpError.notFound);

    expect(sut.load(), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 500", () async {
    httpClient.mockRequestError(HttpError.serverError);

    expect(sut.load(), throwsA(DomainError.unexpected));
  });

  test("Should throw AcessDeniedError if HttpClient returns 403", () async {
    httpClient.mockRequestError(HttpError.forbidden);

    expect(sut.load(), throwsA(DomainError.accessDenied));
  });
}
