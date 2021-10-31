import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usercases.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({@required this.cacheStorage});

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');

      if (data?.isEmpty != false) {
        throw Exception();
      }

      return _map(data);
    } catch(error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    final data = await cacheStorage.fetch('surveys');

    try {
      _map(data);
    } catch(error) {
      cacheStorage.delete('surveys');
    }
  }

  List<SurveyEntity> _map(List<Map> list) {
    return list.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
  }

}