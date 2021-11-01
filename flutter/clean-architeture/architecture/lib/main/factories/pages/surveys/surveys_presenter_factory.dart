import '../../../../presentation/presenters/presenter.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SurveysPresenter makeGetxSurveysPresenter() => GetxSurveysPresenter(
      loadSurveys: makeRemoteLoadSurveys()
  );