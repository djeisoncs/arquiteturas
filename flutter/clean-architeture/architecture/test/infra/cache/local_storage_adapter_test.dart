import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:architecture/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  FlutterSecureStorageSpy secureStorage;
  LocalStorageAdapter sut;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('saveSecure', () {
    void mockSaveSecureError() {
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());
    }

    test('Shoud call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    test('Shoud throw if save secure throws', () async {
      mockSaveSecureError();

      expect(sut.saveSecure(key: key, value: value), throwsA(TypeMatcher<Exception>() ));
    });
  });

  group('fetchSecure', () {
    void mockFetchSecure() {
      when(secureStorage.read(key: anyNamed('key'))).thenAnswer((_) async => value);
    }

    setUp(() {
      mockFetchSecure();
    });

    test('Shoud call fetch secure with correct value', () async {
      await sut.fetchSecure(key);

      verify(secureStorage.read(key: key));
    });

    test('Shoud return correct value on sucess', () async {
      final featchValue = await sut.fetchSecure(key);

      expect(featchValue, value);
    });
  });
}