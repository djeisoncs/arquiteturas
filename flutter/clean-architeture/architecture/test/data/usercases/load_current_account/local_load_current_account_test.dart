
import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/domain/usecases/load_current_account.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:architecture/domain/entities/account_entity.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FeatchSecureCacheStore featchSecureCacheStore;

  LocalLoadCurrentAccount({@required this.featchSecureCacheStore});

  @override
  Future<AccountEntity> load() async {
    try {
      final token = await featchSecureCacheStore.fetchSecure('token');
      return AccountEntity(token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class FeatchSecureCacheStore {
  Future<String> fetchSecure(String key);
}

class FeatchSecureCacheStoreSpy extends Mock implements FeatchSecureCacheStore {}

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