import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usercases.dart';
import '../factories.dart';

LoadCurrentAccount makeLocalCurrentAccount() {
  return LocalLoadCurrentAccount(
      featchSecureCacheStore: makeLocalStorageAdapter()
  );
}