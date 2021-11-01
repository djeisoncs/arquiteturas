import '../../../../ui/pages/pages.dart';
import '../../../../presentation/presenters/presenter.dart';

import '../../factories.dart';

SignupPresenter makeGetxSignupPresenter() => GetxSignUpPresenter(
      addAccount: makeRemoteAddAccount(),
      validation: makeSignupValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount()
  );