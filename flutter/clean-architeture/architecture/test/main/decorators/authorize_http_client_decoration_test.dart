import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:architecture/main/decorators/decorators.dart';
import 'package:architecture/data/http/http.dart';

import '../../data/mocks/mocks.dart';

void main() {
  late AuthorizeHttpClientDecorator sut;
  late SecureCacheStorageSpy secureCacheStorage;
  late HttpClientSpy httpClient;

  late String url;
  late String method;
  late String token;
  late String httpResponse;

  late Map body;

  
  setUp(() {
    httpResponse = faker.randomGenerator.string(50);
    token = faker.guid.guid();
    url = faker.internet.httpsUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};

    secureCacheStorage = SecureCacheStorageSpy();
    httpClient = HttpClientSpy();

    sut = AuthorizeHttpClientDecorator(
        featchSecureCacheStorage: secureCacheStorage,
        deleteSecureCacheStorage: secureCacheStorage,
        decoratee: httpClient
    );


    secureCacheStorage.mockFetch(token);
    httpClient.mockRequest(httpResponse);
  });
  
  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);
    
    verify(() => secureCacheStorage.fetch('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(() => httpClient.request(url: url, method: method, body: body, headers: {'x-access-token': token})).called(1);

    await sut.request(url: url, method: method, body: body, headers: {'any_header': 'any_value'});
    verify(() => httpClient.request(url: url, method: method, body: body, headers: {'x-access-token': token, 'any_header': 'any_value'})).called(1);
  });


  test('Should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });

  test('Should throw ForbiddenError if FetchSecireCacheStorage throws', () async {
    secureCacheStorage.mockFetchError();

    expect(sut.request(url: url, method: method, body: body), throwsA(HttpError.forbidden));
    verify(() => secureCacheStorage.delete('token')).called(1);
  });

  test('Should rethrow if decoratee throws', () async {
    httpClient.mockRequestError(HttpError.badRequest);

    expect(sut.request(url: url, method: method, body: body), throwsA(HttpError.badRequest));
  });

  test('Should delete cache if request throws ForbidenError', () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.request(url: url, method: method, body: body);
    await untilCalled(() => secureCacheStorage.delete('token'));

    expect(future, throwsA(HttpError.forbidden));
    verify(() => secureCacheStorage.delete('token')).called(1);
  });
}