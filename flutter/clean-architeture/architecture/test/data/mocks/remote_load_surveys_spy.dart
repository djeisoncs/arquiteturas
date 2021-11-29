import 'package:mocktail/mocktail.dart';

import 'package:architecture/data/usecases/load_surveys/load_surveys.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/domain_error.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {
  When mockLoadCall() => when(() => load());

  void mockLoad(List<SurveyEntity> data) => mockLoadCall().thenAnswer((_) async => data);

  void mockLoadError(DomainError error) => mockLoadCall().thenThrow(error);
}