import 'package:meta/meta.dart';

import '../../domain/usecases/usercases.dart';
import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
    @required this.local
  });

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await remote.load();

      await local.save(surveys);

      return surveys;
    } catch(error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }

      await local.validate();

      return await local.load();
    }
  }
}