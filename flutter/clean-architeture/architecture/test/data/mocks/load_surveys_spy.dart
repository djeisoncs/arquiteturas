import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/usecases/load_surveys.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/domain_error.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {
  When mockLoadCall() => when(() => load());

  void mockLoad(List<SurveyEntity> data) => mockLoadCall().thenAnswer((_) async => data);

  void mockLoadError(DomainError error) => mockLoadCall().thenThrow(error);
}