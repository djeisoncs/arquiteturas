import '../../../../ui/pages/pages.dart';
import '../../../../presentetion/presenters/presenter.dart';

import '../../factories.dart';

SignupPresenter makeGetxSignupPresenter() => GetxSignUpPresenter(
      addAccount: makeRemoteAddAccount(),
      validation: makeSignupValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount()
  );