import 'package:architecture/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:architecture/domain/entities/entities.dart';

import 'package:architecture/data/usecases/usecases.dart';
import 'package:architecture/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteLoadSurveyResult sut;
  HttpClientSpy httpClient;
  String url;
  Map surveyResult;

  Map mockValidData() => 
      {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'answers': [
            {
              'image': faker.internet.httpsUrl(),
              'answer': faker.randomGenerator.string(20),
              'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
              'percent': faker.randomGenerator.integer(100),
              'count': faker.randomGenerator.integer(1000),
            },
            {
              'answer': faker.randomGenerator.string(20),
              'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
              'percent': faker.randomGenerator.integer(100),
              'count': faker.randomGenerator.integer(1000),
            }
          ],
        'date': faker.date.dateTime().toIso8601String()
      };

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    url = faker.internet.httpsUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);

    mockHttpData(mockValidData());
  });

  test("Should call HttpClient with correct values", () async {
    await sut.loadBySurvey();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test("Should return suervey data on 200", () async {
    final result = await sut.loadBySurvey();

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

    expect(sut.loadBySurvey(), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    mockHttpError(HttpError.notFound);

    expect(sut.loadBySurvey(), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 500", () async {
    mockHttpError(HttpError.serverError);

    expect(sut.loadBySurvey(), throwsA(DomainError.unexpected));
  });

  test("Should throw AcessDeniedError if HttpClient returns 403", () async {
    mockHttpError(HttpError.forbidden);

    expect(sut.loadBySurvey(), throwsA(DomainError.accessDenied));
  });
}
