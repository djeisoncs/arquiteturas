import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/data/cache/cache.dart';
import 'package:architecture/data/usecases/usecases.dart';

class FetchCacheStorageSpy extends Mock implements CacheStorage {}

void main() {

  group('load', () {
    LocalLoadSurveys sut;
    FetchCacheStorageSpy fetchCacheStorage;
    List<Map> data;

    List<Map> mockValidData() => [
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'didAnswer': 'false',
        'date': '2020-07-20T00:00:00Z'
      },
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'didAnswer': 'true',
        'date': '2018-02-02T00:00:00Z'
      }
    ];

    PostExpectation mockCallsFetch () => when(fetchCacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockCallsFetch().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockCallsFetch().thenThrow(Exception());

    setUp(() {
      fetchCacheStorage = FetchCacheStorageSpy();
      sut = LocalLoadSurveys(
          cacheStorage: fetchCacheStorage
      );

      mockFetch(mockValidData());
    });

    test('Should call cacheStorage with correct key', () async {
      await sut.load();

      verify(fetchCacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(id: data[0]['id'], question: data[0]['question'], dateTime: DateTime.utc(2020, 7, 20), didAnswer: false),
        SurveyEntity(id: data[0]['id'], question: data[0]['question'], dateTime: DateTime.utc(2018, 2, 2), didAnswer: true)
      ]);
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch([]);

      expect(sut.load(), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is null', () async {
      mockFetch(null);

      expect(sut.load(), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': 'false',
          'date': 'invalid date'
        }
      ]);

      expect(sut.load(), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch([
        {
          'didAnswer': 'false',
          'date': '2020-07-20T00:00:00Z'
        }
      ]);

      expect(sut.load(), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();

      expect(sut.load(), throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    LocalLoadSurveys sut;
    FetchCacheStorageSpy fetchCacheStorage;
    List<Map> data;

    List<Map> mockValidData() => [
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'didAnswer': 'false',
        'date': '2020-07-20T00:00:00Z'
      },
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'didAnswer': 'true',
        'date': '2018-02-02T00:00:00Z'
      }
    ];

    PostExpectation mockCallsFetch () => when(fetchCacheStorage.fetch(any));

    void mockFetch(List<Map> list) {
      data = list;
      mockCallsFetch().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockCallsFetch().thenThrow(Exception());

    setUp(() {
      fetchCacheStorage = FetchCacheStorageSpy();
      sut = LocalLoadSurveys(
          cacheStorage: fetchCacheStorage
      );

      mockFetch(mockValidData());
    });

    test('Should call cacheStorage with correct key', () async {
      await sut.validate();

      verify(fetchCacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': 'false',
          'date': 'invalid date'
        }
      ]);

      await sut.validate();

      verify(fetchCacheStorage.delete('surveys')).called(1);
    });
  });
}