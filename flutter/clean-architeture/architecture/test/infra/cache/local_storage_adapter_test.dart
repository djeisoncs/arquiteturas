import 'package:architecture/infra/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  LocalStorageSpy localStorage;
  LocalStorageAdapter sut;
  String key;
  String value;
  
  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });
  
  test('Shoud call localStorage with correct values', () async {
    await sut.save(key: key, value: value);
    
    verify(localStorage.setItem(key, value)).called(1);
  });
}