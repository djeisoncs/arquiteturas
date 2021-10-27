import '../../../data/http/http.dart';

import '../../factories/factories.dart';
import '../../decorators/decorators.dart';

HttpClient makeHttpAdapter() => AuthorizeHttpClientDecorator(
    decoratee: makeHttpAdapter(),
    featchSecureCacheStorage: makeLocalStorageAdapter()
);