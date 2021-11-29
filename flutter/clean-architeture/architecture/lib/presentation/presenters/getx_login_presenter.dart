import 'package:get/get.dart';


import '../../ui/pages/login/login.dart';
import '../../ui/helpers/errors/errors.dart';

import '../../domain/usecases/usercases.dart';
import '../../domain/helpers/domain_error.dart';

import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

class GetxLoginPresenter extends GetxController with LoadingManager, NavigationManager, FormManager, UiErrorManager implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String? _email;
  String? _password;

  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;

  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount
  });

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validadeField('email');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validadeField('password');
    _validateForm();
  }

  UIError? _validadeField(String field) {
    final formData = {
      'email': _email,
      'password': _password
    };

    final error = validation.validate(field: field, input: formData);

    switch (error) {
      case ValidationError.invalidField: return UIError.invalidField;
      case ValidationError.requiredField: return UIError.requiredField;
      default: return null;
    }
  }

  void _validateForm() {
    isFormValid =
    _emailError.value == null && _passwordError.value == null
        && _email != null && _password != null;
  }

  @override
  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;

      final account = await authentication.auth(AuthenticationParams(email: _email!, password: _password!));
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch(error) {
        case DomainError.invalidCredentials: mainError = UIError.invalidCredentials; break;
        default: mainError = UIError.unexpected;
      }

      isLoading = false;
    }
  }

  @override
  void goToSignUp() {
    navigateTo = '/signup';
  }
}
