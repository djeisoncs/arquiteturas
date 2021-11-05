import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usercases.dart';

import '../factories.dart';

AddAccount makeRemoteAddAccount() {
  return RemoteAddAccount(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('signup')
  );
}