import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/domain/usecases/save_survey_result.dart';

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {
  When mockSaveCall() => when(() => save(answer: any(named: 'answer')));

  void mockSave(SurveyResultEntity data) => mockSaveCall().thenAnswer((_) async => data);

  void mockSaveError(DomainError error) => mockSaveCall().thenThrow(error);
}