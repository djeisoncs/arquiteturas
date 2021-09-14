import '../../../../presentetion/presenters/presenter.dart';
import '../../../../ui/pages/login/login.dart';
import '../../factories.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation()
  );
}