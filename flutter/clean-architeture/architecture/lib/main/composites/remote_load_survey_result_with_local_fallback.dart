import 'package:meta/meta.dart';

import '../../domain/usecases/usercases.dart';
import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';

class RemoteLoadSurveyResultWithLocalFallBack implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallBack(
      {@required this.remote, @required this.local});

  @override
  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final surveyResult = await remote.loadBySurvey(surveyId: surveyId);
      local.save(surveyId: surveyId, surveyResult: surveyResult);

      return surveyResult;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }

      await local.validate(surveyId);

      return await local.loadBySurvey(surveyId: surveyId);
    }
  }
}