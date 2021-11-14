import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usercases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

import '../mixins/mixins.dart';

class GetxSurveyResultPresenter extends GetxController with LoadingManager, SessionManager implements  SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _surveyResult = Rx<SurveyResultViewModel>();

  GetxSurveyResultPresenter({
    @required this.loadSurveyResult,
    @required this.surveyId,
  });

  @override
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = true;

      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);

      _surveyResult.value = SurveyResultViewModel(
          surveyId: surveyResult.surveyId,
          question: surveyResult.question,
          answers: surveyResult.answers.map((answer) => SurveyAnswerViewModel(
              answer: answer.image,
              isCurrentAnswer: answer.isCurrentAnswer,
              percent: '${answer.percent}%'
          )).toList()
      );
    } on DomainError catch(error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }
}