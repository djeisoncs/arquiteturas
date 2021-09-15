import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:architecture/data/cache/cache.dart';
import 'package:architecture/domain/helpers/helpers.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/data/usecases/usecases.dart';

class FeatchSecureCacheStoreSpy extends Mock implements FeatchSecureCacheStorage {}

void main() {
  FeatchSecureCacheStoreSpy featchSecureCacheStore;
  LocalLoadCurrentAccount sut;
  String token;

  PostExpectation mockFetchSecureCall() => when(featchSecureCacheStore.fetchSecure(any));

  void mockFetchSecure() => mockFetchSecureCall().thenAnswer((_) async => token);

  void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

  setUp(() {
    featchSecureCacheStore = FeatchSecureCacheStoreSpy();
    sut = LocalLoadCurrentAccount(featchSecureCacheStore: featchSecureCacheStore);
    token = Faker().guid.guid();
    mockFetchSecure();
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(featchSecureCacheStore.fetchSecure('token'));
  });

  test('Should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage fails', () async {
    mockFetchSecureError();

    expect(sut.load(), throwsA(DomainError.unexpected));
  });
}