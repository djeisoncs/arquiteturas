import '../../../../presentation/presenters/presenter.dart';
import '../../../../ui/pages/login/login.dart';
import '../../factories.dart';

LoginPresenter makeGetxLoginPresenter() => GetxLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount()
  );