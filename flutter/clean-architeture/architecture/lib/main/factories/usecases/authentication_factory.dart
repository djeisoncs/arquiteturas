import '../../../data/usecases/authentication/authentication.dart';
import '../../../domain/usecases/usercases.dart';

import '../factories.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('login')
  );
}