import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/data/cache/cache.dart';
import 'package:architecture/data/usecases/usecases.dart';

import '../../../mocks/mocks.dart';

class FetchCacheStorageSpy extends Mock implements CacheStorage {}

void main() {

  group('load', () {
    LocalLoadSurveys sut;
    FetchCacheStorageSpy fetchCacheStorage;
    List<Map> data;


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

      mockFetch(FakeSurveysFactory.makeCacheJson());
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
      mockFetch(FakeSurveysFactory.makeInvalidCacheJson());

      expect(sut.load(), throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(FakeSurveysFactory.makeIncompleteCacheJson());

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

      mockFetch(FakeSurveysFactory.makeCacheJson());
    });

    test('Should call cacheStorage with correct key', () async {
      await sut.validate();

      verify(fetchCacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch(FakeSurveysFactory.makeInvalidCacheJson());

      await sut.validate();

      verify(fetchCacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch(FakeSurveysFactory.makeIncompleteCacheJson());

      await sut.validate();

      verify(fetchCacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if fetch fails', () async {
      mockFetchError();

      await sut.validate();

      verify(fetchCacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    LocalLoadSurveys sut;
    FetchCacheStorageSpy cacheStorage;
    List<SurveyEntity> surveys;

    PostExpectation mockCallsSave () => when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));


    void mockSaveError() => mockCallsSave().thenThrow(Exception());

    setUp(() {
      cacheStorage = FetchCacheStorageSpy();
      sut = LocalLoadSurveys(
          cacheStorage: cacheStorage
      );

      surveys = FakeSurveysFactory.makeEntities();
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

      verify(cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();

      expect(sut.save(surveys), throwsA(DomainError.unexpected));
    });
  });
}