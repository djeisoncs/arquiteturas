import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/data/cache/cache.dart';
import 'package:architecture/data/http/http_client.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FeatchSecureCacheStorage featchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    @required this.featchSecureCacheStorage,
    @required this.decoratee
  });

  @override
  Future<dynamic> request({@required String url, @required String method, Map body, Map headers}) async {
    final token = await featchSecureCacheStorage.fetchSecure('token');

    final athorizedHeaders = headers ?? {} ..addAll({'x-access-token': token});

    return await decoratee.request(url: url, method: method, body: body, headers: athorizedHeaders);
  }
}

class FeatchSecureCacheStorageSpy extends Mock implements FeatchSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  AuthorizeHttpClientDecorator sut;
  FeatchSecureCacheStorageSpy featchSecureCacheStorage;
  HttpClientSpy httpClient;

  String url;
  String method;
  String token;
  String httpResponse;

  Map body;

  void mockToken() {
    token = faker.guid.guid();
    when(featchSecureCacheStorage.fetchSecure(any)).thenAnswer((_) async => token);
  }

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);

    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
      headers: anyNamed('headers')
    )).thenAnswer((_) async => httpResponse);
  }
  
  setUp(() {
    featchSecureCacheStorage = FeatchSecureCacheStorageSpy();
    httpClient = HttpClientSpy();

    sut = AuthorizeHttpClientDecorator(
        featchSecureCacheStorage: featchSecureCacheStorage,
        decoratee: httpClient
    );

    url = faker.internet.httpsUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};

    mockToken();
    mockHttpResponse();
  });
  
  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);
    
    verify(featchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(httpClient.request(url: url, method: method, body: body, headers: {'x-access-token': token})).called(1);

    await sut.request(url: url, method: method, body: body, headers: {'any_header': 'any_value'});
    verify(httpClient.request(url: url, method: method, body: body, headers: {'x-access-token': token, 'any_header': 'any_value'})).called(1);
  });


  test('Should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });
}