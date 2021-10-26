import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/data/cache/cache.dart';
import 'package:architecture/data/http/http_client.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FeatchSecureCacheStorage featchSecureCacheStorage;

  AuthorizeHttpClientDecorator({@required this.featchSecureCacheStorage});

  @override
  Future<void> request({String url, String method, Map body, Map headers}) async {
    await featchSecureCacheStorage.fetchSecure('token');
  }
}

class FeatchSecureCacheStorageSpy extends Mock implements FeatchSecureCacheStorage {}

void main() {
  AuthorizeHttpClientDecorator sut;
  FeatchSecureCacheStorageSpy featchSecureCacheStorage;
  
  setUp(() {
    featchSecureCacheStorage = FeatchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(featchSecureCacheStorage: featchSecureCacheStorage);
  });
  
  test('Should Call FetchSecureCacheStorage with correct key', () async {
    await sut.request();
    
    verify(featchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}