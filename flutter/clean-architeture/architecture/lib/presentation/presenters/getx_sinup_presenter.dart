import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/errors/errors.dart';

import '../../domain/usecases/usercases.dart';
import '../../domain/helpers/domain_error.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController implements SignupPresenter  {

  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _name;
  String _password;
  String _passwordConfirmation;

  var _emailError = Rx<UIError>();
  var _nameError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _passwordConfirmationError = Rx<UIError>();
  var _mainError = Rx<UIError>();
  var _navigateTo = RxString();
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;
  Stream<UIError> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount,
  });

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validadeField('email');
    _validateForm();
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validadeField('name');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validadeField('password');
    _validateForm();
  }

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validadeField('passwordConfirmation');
    _validateForm();
  }

  UIError _validadeField(String field) {
    final formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation
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
        _emailError.value == null && _email != null
        && _nameError.value == null && _name != null
        && _passwordError.value == null && _password != null
        && _passwordConfirmationError.value == null && _passwordConfirmation  != null;
  }

  @override
  Future<void> signUp() async {
    try {
      _mainError.value = null;
      _isLoading.value = true;

      final account = await addAccount.add(AddAccountParams(name: _name, email: _email, password: _password, passwordConfirmation: _passwordConfirmation));
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch(error) {
        case DomainError.emailInUse: _mainError.value = UIError.emailInUse; break;
        default: _mainError.value = UIError.unexpected;
      }

      _isLoading.value = false;
    }
  }

  @override
  void goToLogin() {
    _navigateTo.value = '/login';
  }
}