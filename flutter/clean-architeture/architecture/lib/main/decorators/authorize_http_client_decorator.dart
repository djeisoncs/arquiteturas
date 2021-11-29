

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FeatchSecureCacheStorage featchSecureCacheStorage;
  final DeleteSecureCacheStorage deleteSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    required this.featchSecureCacheStorage,
    required this.deleteSecureCacheStorage,
    required this.decoratee
  });

  @override
  Future<dynamic> request({required String url, required String method, Map? body, Map? headers}) async {
    try {
      final token = await featchSecureCacheStorage.fetch('token');

      final athorizedHeaders = headers ?? {}..addAll({'x-access-token': token});

      return await decoratee.request(url: url, method: method, body: body, headers: athorizedHeaders);
    }  catch(error) {
      if (error is HttpError && error != HttpError.forbidden) {
        rethrow;
      }

      await deleteSecureCacheStorage.delete('token');
      throw HttpError.forbidden;
    }
  }
}