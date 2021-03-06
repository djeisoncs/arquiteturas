import 'package:architecture/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:architecture/domain/entities/entities.dart';

import 'package:architecture/data/usecases/usecases.dart';
import 'package:architecture/data/http/http.dart';

import '../../../mocks/mocks.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteSaveSurveyResult sut;
  HttpClientSpy httpClient;
  String url;
  String answer;
  Map surveyResult;

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')
  ));

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);
  
  setUp(() {
    url = faker.internet.httpsUrl();
    answer = faker.lorem.sentence();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);

    mockHttpData(FakeSurveyResultFactory.makeApiJson());
  });

  test("Should call HttpClient with correct values", () async {
    await sut.save(answer: answer);

    verify(httpClient.request(url: url, method: 'put', body: {'answer': answer}));
  });

  test("Should return suervey data on 200", () async {
    final result = await sut.save(answer: answer);

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
    mockHttpData({"invalid_key": "invalid_value"});

    expect(sut.save(answer: answer), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    mockHttpError(HttpError.notFound);

    expect(sut.save(answer: answer), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 500", () async {
    mockHttpError(HttpError.serverError);

    expect(sut.save(answer: answer), throwsA(DomainError.unexpected));
  });

  test("Should throw AcessDeniedError if HttpClient returns 403", () async {
    mockHttpError(HttpError.forbidden);

    expect(sut.save(answer: answer), throwsA(DomainError.accessDenied));
  });

}
