import 'package:mocktail/mocktail.dart';

import 'package:architecture/data/cache/cache.dart';

class CacheStorageSpy extends Mock implements CacheStorage {

  CacheStorageSpy(){
    mockDelete();
    mockSave();
  }

  When mockCallsFetch () => when(() => fetch(any()));
  void mockFetch(dynamic json) => mockCallsFetch().thenAnswer((_) async => json);
  void mockFetchError() => mockCallsFetch().thenThrow(Exception());

  When mockDeleteCall() => when(() => delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => mockDeleteCall().thenThrow(Exception());

  When mockSaveCall() => when(() => save(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}