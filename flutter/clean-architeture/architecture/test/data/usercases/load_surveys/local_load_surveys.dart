import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/data/cache/cache.dart';
import 'package:architecture/domain/entities/survey_entity.dart';
import 'package:architecture/domain/usecases/usercases.dart';

class LocalLoadSurveys /*implements LoadSurveys */{
  final CacheStorage cacheStorage;

  LocalLoadSurveys({@required this.cacheStorage});

  @override
  Future<void> load() async {
  // Future<List<SurveyEntity>> load() {
    await cacheStorage.fetch('surveys');
  }

}

class FetchCacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  LocalLoadSurveys sut;
  FetchCacheStorageSpy fetchCacheStorage;

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(
        cacheStorage: fetchCacheStorage
    );
  });

  test('Should call FeatchCacheStorage with correct key', () async {
    sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
  });
}