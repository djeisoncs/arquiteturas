import '../../../../presentetion/presenters/presenter.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(loadCurrentAccount: makeLocalCurrentAccount());
}