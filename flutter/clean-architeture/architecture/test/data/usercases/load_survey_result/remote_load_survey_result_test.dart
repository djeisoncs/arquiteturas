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
  late RemoteLoadSurveyResult sut;
  late HttpClientSpy httpClient;
  late String url;
  late Map surveyResult;
  late String surveyId;

  setUp(() {
    surveyId = faker.guid.guid();
    url = faker.internet.httpsUrl();
    surveyResult = ApiFactory.makeSurveyResultJson();

    httpClient = HttpClientSpy();
    httpClient.mockRequest(surveyResult);
    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);

  });

  test("Should call HttpClient with correct values", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test("Should return suervey data on 200", () async {
    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(result, SurveyResultEntity(
        surveyId: surveyResult['surveyId'],
        question: surveyResult['question'],
        answers: [
          SurveyAnswerEntity(
              image: surveyResult['answers'][0]['image'],
              answer: surveyResult['answers'][0]['answer'],
              isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][0]['percent']
          ),
          SurveyAnswerEntity(
              answer: surveyResult['answers'][1]['answer'],
              isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][1]['percent']
          )
        ]
    ));
  });

  test("Should throw Unexpected if HttpClient returns 200 with invalid data", () async {
    httpClient.mockRequest(ApiFactory.makeInvalidJson());

    expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    httpClient.mockRequestError(HttpError.notFound);

    expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 500", () async {
    httpClient.mockRequestError(HttpError.serverError);

    expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
  });

  test("Should throw AcessDeniedError if HttpClient returns 403", () async {
    httpClient.mockRequestError(HttpError.forbidden);

    expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.accessDenied));
  });
}
