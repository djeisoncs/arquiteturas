import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usercases.dart';
import '../factories.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(
      saveSecureCacheStorage: makeLocalStorageAdapter()
  );
}