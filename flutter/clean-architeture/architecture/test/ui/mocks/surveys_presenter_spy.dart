import 'dart:async';

import 'package:architecture/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {
  final surveysController = StreamController<List<SurveyViewModel>>();
  final navigateToController = StreamController<String?>();
  final isSessionExpiredController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();

  SurveysPresenterSpy() {
    when(() => loadData()).thenAnswer((_) async => _);
    when(() => isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
    when(() => navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(() => surveysStream).thenAnswer((_) => surveysController.stream);
    when(() => isLoadingStream).thenAnswer((_) => isLoadingController.stream);
  }

  void emitSurveys(List<SurveyViewModel> surveys) => surveysController.add(surveys);

  void emitSurveysError(String error) => surveysController.addError(error);

  void emitLoading([bool show = true]) => isLoadingController.add(show);

  void emitSessionExpired([bool show = true]) => isSessionExpiredController.add(show);

  void emitNavigate(String route) => navigateToController.add(route);

  void dispose() {
    surveysController.close();
    isSessionExpiredController.close();
    isLoadingController.close();
    navigateToController.close();
  }
}