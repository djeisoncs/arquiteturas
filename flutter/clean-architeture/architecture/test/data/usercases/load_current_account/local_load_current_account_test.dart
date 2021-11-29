import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/data/usecases/usecases.dart';

import '../../mocks/mocks.dart';

void main() {
  late SecureCacheStorageSpy secureCacheStore;
  late LocalLoadCurrentAccount sut;
  late String token;

  setUp(() {
    secureCacheStore = SecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(featchSecureCacheStore: secureCacheStore);
    token = Faker().guid.guid();
    secureCacheStore.mockFetch(token);
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(() => secureCacheStore.fetch('token'));
  });

  test('Should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token: token));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage fails', () async {
    secureCacheStore.mockFetchError();

    expect(sut.load(), throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage returns null', () async {
    secureCacheStore.mockFetch(null);

    expect(sut.load(), throwsA(DomainError.unexpected));
  });
}