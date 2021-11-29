import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/entities/survey_result_entity.dart';
import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/data/usecases/load_survey_result/load_survey_result.dart';

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {

  LocalLoadSurveyResultSpy() {
    mockValidate();
    mockSave();
  }

  When mockLoadBySurveyCall() => when(() => loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoadBySurvey(SurveyResultEntity data) => mockLoadBySurveyCall().thenAnswer((_) async => data);
  void mockLoadBySurveyError() => mockLoadBySurveyCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => validate(any()));
  void mockValidate() => mockValidateCall().thenAnswer((_) async => _);
  void mockValidateError() => mockValidateCall().thenThrow(Exception());

  When mockSaveCall() => when(() => save(any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}