import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LocalLoadCurrentAccount {
  final FeatchSecureCacheStore featchSecureCacheStore;

  LocalLoadCurrentAccount({@required this.featchSecureCacheStore});

  @override
  Future<void> load() async {
    await featchSecureCacheStore.fetchSecure('token');
  }
}

abstract class FeatchSecureCacheStore {
  Future<void> fetchSecure(String key);
}

class FeatchSecureCacheStoreSpy extends Mock implements FeatchSecureCacheStore {}

void main() {

  test('Should call FetchSecureCacheStorage with correct value', () async {
    final featchSecureCacheStore = FeatchSecureCacheStoreSpy();
    final sut = LocalLoadCurrentAccount(featchSecureCacheStore: featchSecureCacheStore);

    await sut.load();

    verify(featchSecureCacheStore.fetchSecure('token'));
  });
}