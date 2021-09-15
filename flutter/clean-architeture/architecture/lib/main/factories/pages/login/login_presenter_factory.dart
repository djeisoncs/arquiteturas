import '../../../../presentetion/presenters/presenter.dart';
import '../../../../ui/pages/login/login.dart';
import '../../factories.dart';

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount()
  );
}