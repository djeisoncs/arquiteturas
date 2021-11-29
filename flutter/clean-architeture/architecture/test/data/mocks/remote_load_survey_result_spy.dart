import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/entities/survey_result_entity.dart';
import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/data/usecases/load_survey_result/load_survey_result.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
  When mockLoadBySurveyCall() => when(() => loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLoadBySurvey(SurveyResultEntity data) => mockLoadBySurveyCall().thenAnswer((_) async => data);

  void mockLoadBySurveyError(DomainError error) => mockLoadBySurveyCall().thenThrow(error);
}