import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/data/usecases/save_current_account/save_current_account.dart';

import '../../mocks/mocks.dart';


void main() {
  late LocalSaveCurrentAccount sut;
  late SecureCacheStorageSpy secureCacheStorage;
  late AccountEntity account;

  setUp(() {
    secureCacheStorage = SecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: secureCacheStorage);
    account = AccountEntity(token: faker.guid.guid());
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(() => secureCacheStorage.save(key: 'token', value: account.token));
  });

  test('Should throw Unexpected if SaveSecureCacheStorage throws', () async {
    secureCacheStorage.mockSaveError();
    expect(sut.save(account), throwsA(DomainError.unexpected));
  });
}