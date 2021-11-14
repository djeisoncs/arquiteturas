import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/main/decorators/decorators.dart';
import 'package:architecture/data/http/http.dart';
import 'package:architecture/data/cache/cache.dart';
import 'package:architecture/data/http/http_client.dart';

class FeatchSecureCacheStorageSpy extends Mock implements FeatchSecureCacheStorage {}

class DeleteSecureCacheStorageSpy extends Mock implements DeleteSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  AuthorizeHttpClientDecorator sut;
  FeatchSecureCacheStorageSpy featchSecureCacheStorage;
  DeleteSecureCacheStorageSpy deleteSecureCacheStorage;
  HttpClientSpy httpClient;

  String url;
  String method;
  String token;
  String httpResponse;

  Map body;

  PostExpectation mockTokenCall() => when(featchSecureCacheStorage.fetch(any));

  void mockToken() {
    token = faker.guid.guid();
   mockTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() {
    mockTokenCall().thenThrow(Exception());
  }

  PostExpectation mockHttpResponseCall() =>
      when(httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
          headers: anyNamed('headers')
      ));

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);

    mockHttpResponseCall().thenAnswer((_) async => httpResponse);
  }

  void mockHttpResponseError(HttpError error) {
    mockHttpResponseCall().thenThrow(error);
  }
  
  setUp(() {
    featchSecureCacheStorage = FeatchSecureCacheStorageSpy();
    deleteSecureCacheStorage = DeleteSecureCacheStorageSpy();
    httpClient = HttpClientSpy();

    sut = AuthorizeHttpClientDecorator(
        featchSecureCacheStorage: featchSecureCacheStorage,
        deleteSecureCacheStorage: deleteSecureCacheStorage,
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
    
    verify(featchSecureCacheStorage.fetch('token')).called(1);
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

  test('Should throw ForbiddenError if FetchSecireCacheStorage throws', () async {
    mockTokenError();

    expect(sut.request(url: url, method: method, body: body), throwsA(HttpError.forbidden));
    verify(deleteSecureCacheStorage.delete('token')).called(1);
  });

  test('Should rethrow if decoratee throws', () async {
    mockHttpResponseError(HttpError.badRequest);

    expect(sut.request(url: url, method: method, body: body), throwsA(HttpError.badRequest));
  });

  test('Should delete cache if request throws ForbidenError', () async {
    mockHttpResponseError(HttpError.forbidden);

    final future = sut.request(url: url, method: method, body: body);
    await untilCalled(deleteSecureCacheStorage.delete('token'));

    expect(future, throwsA(HttpError.forbidden));
    verify(deleteSecureCacheStorage.delete('token')).called(1);
  });
}