import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/data/cache/cache.dart';
import 'package:architecture/data/usecases/usecases.dart';

import '../../../mocks/fake_survey_result_factory.dart';

class FetchCacheStorageSpy extends Mock implements CacheStorage {}

void main() {

  group('loadBySurvey', () {
    LocalLoadSurveyResult sut;
    FetchCacheStorageSpy fetchCacheStorage;
    Map data;
    String surveyId;

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

      mockFetch(FakeSurveyResultFactory.makeCacheJson());
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
      mockFetch(FakeSurveyResultFactory.makeInvalidCacheJson());

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });
  });


  group('validate', () {
    LocalLoadSurveyResult sut;
    FetchCacheStorageSpy fetchCacheStorage;
    Map data;
    String surveyId;

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

      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());
    });

    test('Should call cacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(fetchCacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch(FakeSurveyResultFactory.makeInvalidCacheJson());

      await sut.validate(surveyId);

      verify(fetchCacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());

      await sut.validate(surveyId);

      verify(fetchCacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if fetch fails', () async {
      mockFetchError();

      await sut.validate(surveyId);

      verify(fetchCacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    LocalLoadSurveyResult sut;
    FetchCacheStorageSpy cacheStorage;
    SurveyResultEntity surveyResult;


    PostExpectation mockCallsSave () => when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));


    void mockSaveError() => mockCallsSave().thenThrow(Exception());

    setUp(() {
      cacheStorage = FetchCacheStorageSpy();
      sut = LocalLoadSurveyResult(
          cacheStorage: cacheStorage
      );

      surveyResult = FakeSurveyResultFactory.makeEntity();
    });

    test('Should call cacheStorage with correct values', () async {
      final json = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'percent': '40',
            'isCurrentAnswer': 'true',
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'percent': '60',
            'isCurrentAnswer': 'false',
          }
        ]
      };

      await sut.save(surveyResult);

      verify(cacheStorage.save(key: 'survey_result/${surveyResult.surveyId}', value: json)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();

      expect(sut.save(surveyResult), throwsA(DomainError.unexpected));
    });
  });
}