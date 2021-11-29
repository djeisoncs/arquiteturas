import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:architecture/infra/cache/cache.dart';

import '../mocks/local_storage_spy.dart';

void main() {
  late LocalStorageSpy localStorage;
  late LocalStorageAdapter sut;
  late String key;
  dynamic value;

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  group('save', () {
    test('Shoud call localStorage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(() => localStorage.deleteItem(key)).called(1);
      verify(() => localStorage.setItem(key, value)).called(1);
    });

    test('Shoud throw if deleteItem throws', () async {
      localStorage.mockDeleteError();

      expect(sut.save(key: key, value: value), throwsA(const TypeMatcher<Exception>()));
    });

    test('Shoud throw if setItem throws', () async {
      localStorage.mockSaveError();

      expect(sut.save(key: key, value: value), throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('Shoud call localStorage with correct values', () async {
      await sut.delete(key);

      verify(() => localStorage.deleteItem(key)).called(1);
    });

    test('Shoud throw if deleteItem throws', () async {
      localStorage.mockDeleteError();

      expect(sut.delete(key), throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    late String result;

    setUp(() {
      result = faker.randomGenerator.string(50);
      localStorage.mockFetch(result);
    });

    test('Shoud call localStorage with correct values', () async {
      await sut.fetch(key);

      verify(() => localStorage.getItem(key)).called(1);
    });

    test('Shoud return same value as localStorage', () async {
      final data = await sut.fetch(key);

      expect(data, result);
    });

    test('Shoud throw if getItem throws', () async {
      localStorage.mockFetchError();

      expect(sut.fetch(key), throwsA(TypeMatcher<Exception>()));
    });
  });
}