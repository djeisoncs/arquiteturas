import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usercases.dart';

import '../../../data/cache/cache.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FeatchSecureCacheStorage featchSecureCacheStore;

  LocalLoadCurrentAccount({@required this.featchSecureCacheStore});

  @override
  Future<AccountEntity> load() async {
    try {
      final token = await featchSecureCacheStore.fetch('token');
      return AccountEntity(token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}