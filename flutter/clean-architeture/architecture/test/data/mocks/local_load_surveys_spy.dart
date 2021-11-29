import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/entities/survey_entity.dart';
import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/data/usecases/usecases.dart';

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {

  LocalLoadSurveysSpy() {
    mockValidate();
    mockSave();
  }

  When mockLoadCall() => when(() => load());
  void mockLoad(List<SurveyEntity> data) => mockLoadCall().thenAnswer((_) async => data);
  void mockLoadError() => mockLoadCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => validate());
  void mockValidate() => mockValidateCall().thenAnswer((_) async => _);
  void mockValidateError() => mockValidateCall().thenThrow(Exception());

  When mockSaveCall() => when(() => save(any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}