import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/usecases/usercases.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {

  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
    } catch(error) {
      throw DomainError.unexpected;
    }
  }

}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({@required String key, @required String value});
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageSpy saveSecureCacheStorage;
  AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw Unexpected if SaveSecureCacheStorage throws', () async {
    when(saveSecureCacheStorage.saveSecure(key: anyNamed('key'), value: anyNamed('value')))
    .thenThrow(Exception());

    expect(sut.save(account), throwsA(DomainError.unexpected));
  });
}