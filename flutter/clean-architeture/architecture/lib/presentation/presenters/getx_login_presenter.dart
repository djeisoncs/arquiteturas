import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../ui/pages/login/login.dart';
import '../../ui/helpers/errors/errors.dart';

import '../../domain/usecases/usercases.dart';
import '../../domain/helpers/domain_error.dart';

import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

class GetxLoginPresenter extends GetxController with LoadingManager, NavigationManager implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  var _emailError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _mainError = Rx<UIError>();
  var _isFormValid = false.obs;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get mainErrorStream => _mainError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount
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

  UIError _validadeField(String field) {
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
    _isFormValid.value =
    _emailError.value == null && _passwordError.value == null
        && _email != null && _password != null;
  }

  @override
  Future<void> auth() async {
    try {
      _mainError.value = null;
      isLoading = true;

      final account = await authentication.auth(AuthenticationParams(email: _email, password: _password));
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch(error) {
        case DomainError.invalidCredentials: _mainError.value = UIError.invalidCredentials; break;
        default: _mainError.value = UIError.unexpected;
      }

      isLoading = false;
    }
  }

  @override
  void goToSignUp() {
    navigateTo = '/signup';
  }
}
