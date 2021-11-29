import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/data/usecases/usecases.dart';

import '../../../domain/mocks/entity_factory.dart';
import '../../../infra/mocks/cache_factory.dart';
import '../../mocks/cache_sotrage_spy.dart';

void main() {
  late LocalLoadSurveys sut;
  late CacheStorageSpy cacheStorage;
  late List<Map> data;

  setUp(() {
    cacheStorage = CacheStorageSpy();
    data = CacheFactory.makeSurveyList();
    cacheStorage.mockFetch(data);

    sut = LocalLoadSurveys(
        cacheStorage: cacheStorage
    );
  });

  group('load', () {

    test('Should call cacheStorage with correct key', () async {
      await sut.load();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(id: data[0]['id'], question: data[0]['question'], dateTime: DateTime.utc(2020, 7, 20), didAnswer: false),
        SurveyEntity(id: data[0]['id'], question: data[0]['question'], dateTime: DateTime.utc(2018, 2, 2), didAnswer: true)
      ]);
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      cacheStorage.mockFetch([]);

      expect(sut.load(), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyList());

      expect(sut.load(), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyList());

      expect(sut.load(), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      cacheStorage.mockFetchError();

      expect(sut.load(), throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {

    test('Should call cacheStorage with correct key', () async {
      await sut.validate();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyList());

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyList());

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if fetch fails', () async {
      cacheStorage.mockFetchError();

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    late List<SurveyEntity> surveys;

    setUp(() {
      surveys = EntityFactory.makeSurveyList();
    });

    test('Should call cacheStorage with correct values', () async {
      final list = [{
        'id': surveys[0].id,
        'question': surveys[0].question,
        'date': '2020-02-02T00:00:00.000Z',
        'didAnswer': 'true',
      },
      {
        'id': surveys[1].id,
        'question': surveys[1].question,
        'date': '2018-12-20T00:00:00.000Z',
        'didAnswer': 'false',
      }];

      await sut.save(surveys);

      verify(() => cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      cacheStorage.mockSaveError();

      expect(sut.save(surveys), throwsA(DomainError.unexpected));
    });
  });
}