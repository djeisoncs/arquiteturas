import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/data/usecases/usecases.dart';

import '../../../domain/mocks/entity_factory.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/cache_sotrage_spy.dart';

void main() {
  late LocalLoadSurveyResult sut;
  late CacheStorageSpy cacheStorage;
  late Map data;
  late String surveyId;

  setUp(() {
    surveyId = faker.guid.guid();
    data = CacheFactory.makeSurveyResult();

    cacheStorage = CacheStorageSpy();
    cacheStorage.mockFetch(data);

    sut = LocalLoadSurveyResult(
        cacheStorage: cacheStorage
    );
  });

  group('loadBySurvey', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return surveyResult on success', () async {
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

      expect(surveyResult, SurveyResultEntity(
          surveyId: data['surveyId'],
          question: data['question'],
          answers: [
            SurveyAnswerEntity(
              image: data['answers'][0]['image'],
              answer: data['answers'][0]['answer'],
              percent: 40,
              isCurrentAnswer: true,
            ),
            SurveyAnswerEntity(
              answer: data['answers'][1]['answer'],
              percent: 60,
              isCurrentAnswer: false,
            )
          ]
      ));
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      cacheStorage.mockFetch({});

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyResult());

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyResult());

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      cacheStorage.mockFetchError();

      expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
    });
  });


  group('validate', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyResult());

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyResult());

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if fetch fails', () async {
      cacheStorage.mockFetchError();

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    late SurveyResultEntity surveyResult;

    setUp(() {
      surveyResult = EntityFactory.makeSurveyResult();
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

      verify(() => cacheStorage.save(key: 'survey_result/${surveyResult.surveyId}', value: json)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      cacheStorage.mockSaveError();

      expect(sut.save(surveyResult), throwsA(DomainError.unexpected));
    });
  });
}