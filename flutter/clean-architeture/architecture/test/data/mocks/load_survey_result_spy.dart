import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/usecases/load_survey_result.dart';
import 'package:architecture/domain/entities/survey_result_entity.dart';
import 'package:architecture/domain/helpers/domain_error.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {
  When mockLoadCall() => when(() => loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLoad(SurveyResultEntity data) => mockLoadCall().thenAnswer((_) async => data);

  void mockLoadError(DomainError error) => mockLoadCall().thenThrow(error);
}