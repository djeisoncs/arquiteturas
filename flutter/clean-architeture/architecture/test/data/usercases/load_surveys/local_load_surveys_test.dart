import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/domain/usecases/usercases.dart';

import 'package:architecture/data/cache/cache.dart';
import 'package:architecture/data/models/models.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({@required this.cacheStorage});

  @override
  Future<List<SurveyEntity>> load() async{
    try {
      final data = await cacheStorage.fetch('surveys');

      if (data?.isEmpty != false) {
        throw Exception();
      }

      return data.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
    } catch(error) {
      throw DomainError.unexpected;
    }
  }

}

class FetchCacheStorageSpy extends Mock implements CacheStorage {}

void main() {
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

  test('Should call FeatchCacheStorage with correct key', () async {
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
}