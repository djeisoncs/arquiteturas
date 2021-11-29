import 'dart:async';

import 'package:architecture/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {
  final surveyResultController = StreamController<SurveyResultViewModel?>();
  final isSessionExpiredController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();

  SurveyResultPresenterSpy() {
    when(() => loadData()).thenAnswer((_) async => _);
    when(() => save(answer: any(named: 'answer'))).thenAnswer((_) async => _);
    when(() => isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
    when(() => surveyResultStream).thenAnswer((_) => surveyResultController.stream);
    when(() => isLoadingStream).thenAnswer((_) => isLoadingController.stream);
  }

  void emitSurveyResult(SurveyResultViewModel? viewModel) => surveyResultController.add(viewModel);

  void emitSurveyResultError(String error) => surveyResultController.addError(error);

  void emitLoading([bool show = true]) => isLoadingController.add(show);

  void emitSessionExpired([bool show = true]) => isSessionExpiredController.add(show);

  void dispose() {
    surveyResultController.close();
    isSessionExpiredController.close();
    isLoadingController.close();
  }
}