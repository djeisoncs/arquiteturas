import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usercases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveyResultPresenter implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  GetxSurveyResultPresenter({
    @required this.loadSurveyResult,
    @required this.surveyId,
  });

  final _isLoading = true.obs;
  final _isSessionExpired = RxBool();
  final _surveyResult = Rx<SurveyResultViewModel>();

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;

  @override
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  @override
  Future<void> loadData() async {
    try {
      _isLoading.value = true;

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
    } on DomainError {
      _surveyResult.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}