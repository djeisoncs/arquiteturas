import '../../../data/http/http.dart';
import '../../decorators/decorators.dart';
import '../../factories/factories.dart';

HttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
  decoratee: makeHttpAdapter(),
  featchSecureCacheStorage: makeSecureStorageAdapter(),
  deleteSecureCacheStorage: makeSecureStorageAdapter(),
);