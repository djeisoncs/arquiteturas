import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/data/cache/cache.dart';
import 'package:architecture/data/usecases/usecases.dart';

class FetchCacheStorageSpy extends Mock implements CacheStorage {}

void main() {

  group('loadBySurvey', () {
    LocalLoadSurveyResult sut;
    FetchCacheStorageSpy fetchCacheStorage;
    Map data;
    String surveyId;

    Map mockValidData() => {
      'surveyId': faker.guid.guid(),
      'question': faker.lorem.sentence(),
      'answers': [
        {
          'image': faker.internet.httpsUrl(),
          'answer': faker.lorem.sentence(),
          'isCurrentAnswer': 'true',
          'percent': '40'
        },
        {
          'answer': faker.lorem.sentence(),
          'isCurrentAnswer': 'false',
          'percent': '60'
        },
      ]
    };

    PostExpectation mockCallsFetch () => when(fetchCacheStorage.fetch(any));

    void mockFetch(Map json) {
      data = json;
      mockCallsFetch().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockCallsFetch().thenThrow(Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      fetchCacheStorage = FetchCacheStorageSpy();
      sut = LocalLoadSurveyResult(
          cacheStorage: fetchCacheStorage
      );

      mockFetch(mockValidData());
    });

    test('Should call cacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(fetchCacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return a list of surveyResult on success', () async {
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

      expect(surveyResult, SurveyResultEntity(
          surveyId: data['surveyId'],
          question: data['question'],
          answers: [
            SurveyAnswerEntity(
                image: data['answers'][0]['image'],
                answer: data['answers'][0]['answer'],
                isCurrentAnswer: true,
                percent: 40
            ),
            SurveyAnswerEntity(
                answer: data['answers'][1]['answer'],
                isCurrentAnswer: false,
                percent: 60
            )
          ])
      );
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch({});

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is null', () async {
      mockFetch(null);

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch(
        {
          'surveyId': faker.guid.guid(),
          'question': faker.lorem.sentence(),
          'answers': [{
            'image': faker.internet.httpsUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid bool',
            'percente': 'invalid int'
          }]
        }
      );

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(
          {
            'surveyId': faker.guid.guid(),
          }
      );

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });
  });
}