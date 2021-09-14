import '../../../data/usecases/authentication/authentication.dart';
import '../../../domain/usecases/authentication.dart';

import '../factories.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('login')
  );
}