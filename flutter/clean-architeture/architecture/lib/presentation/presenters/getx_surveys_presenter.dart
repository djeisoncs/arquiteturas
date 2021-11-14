import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usercases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({@required this.loadSurveys});

  final _isLoading = true.obs;
  final _isSessionExpired = RxBool();
  final _surveys = Rx<List<SurveyViewModel>>();
  var _navigateTo = RxString();

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  @override
  Future<void> loadData() async {
    try {
      _isLoading.value = true;

      final surveys = await loadSurveys.load();

      _surveys.value = surveys.map((survey) => SurveyViewModel(
          id: survey.id,
          question: survey.question,
          date: DateFormat('dd MMM yyyy').format(survey.dateTime),
          didAnswer: survey.didAnswer)
      ).toList();
    } on DomainError {
      _surveys.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void goToSurveyResult(String surveyId) {
    _navigateTo.value = '/survey_result/$surveyId';
  }
}