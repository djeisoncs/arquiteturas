import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FeatchSecureCacheStorage featchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    @required this.featchSecureCacheStorage,
    @required this.decoratee
  });

  @override
  Future<dynamic> request({@required String url, @required String method, Map body, Map headers}) async {
    try {
      final token = await featchSecureCacheStorage.fetchSecure('token');

      final athorizedHeaders = headers ?? {}..addAll({'x-access-token': token});

      return await decoratee.request(url: url, method: method, body: body, headers: athorizedHeaders);
    } on HttpError {
      rethrow;
    } catch(error) {
      throw HttpError.forbidden;
    }
  }
}