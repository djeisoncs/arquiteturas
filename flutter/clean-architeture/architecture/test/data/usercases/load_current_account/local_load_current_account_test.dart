
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
    final token = await featchSecureCacheStore.fetchSecure('token');
    return AccountEntity(token);
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

  void mockFetchSecure() {
    when(featchSecureCacheStore.fetchSecure(any)).thenAnswer((_) async => token);
  }
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
}