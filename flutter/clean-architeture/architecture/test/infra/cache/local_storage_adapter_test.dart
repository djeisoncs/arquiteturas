import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  LocalStorageSpy localStorage;
  LocalStorageAdapter sut;
  String key;
  dynamic value;

  void mockDeleteError() => when(localStorage.deleteItem(any)).thenThrow(Exception());

  void mockSaveError() => when(localStorage.setItem(any, any)).thenThrow(Exception());

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  group('save', () {
    test('Shoud call localStorage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(localStorage.deleteItem(key)).called(1);
      verify(localStorage.setItem(key, value)).called(1);
    });

    test('Shoud throw if deleteItem throws', () async {
      mockDeleteError();

      expect(sut.save(key: key, value: value), throwsA(TypeMatcher<Exception>()));
    });

    test('Shoud throw if setItem throws', () async {
      mockSaveError();

      expect(sut.save(key: key, value: value), throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('Shoud call localStorage with correct values', () async {
      await sut.delete(key);

      verify(localStorage.deleteItem(key)).called(1);
    });

    test('Shoud throw if deleteItem throws', () async {
      mockDeleteError();

      expect(sut.delete(key), throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    test('Shoud call localStorage with correct values', () async {
      await sut.fetch(key);

      verify(localStorage.getItem(key)).called(1);
    });
  });
}