import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../ui/pages/login/login.dart';
import '../../ui/helpers/errors/errors.dart';

import '../../domain/usecases/usercases.dart';
import '../../domain/helpers/domain_error.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController  {
  final Validation validation;

  String _email;
  var _emailError = Rx<UIError>(null);
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxSignUpPresenter({
    @required this.validation,
  });

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validadeField(field: 'email', value: email);
    _validateForm();
  }

  UIError _validadeField({String field, String value}) {
    final error = validation.validate(field: field, value: value);

    switch (error) {
      case ValidationError.invalidField: return UIError.invalidField;
      case ValidationError.requiredField: return UIError.requiredField;
      default: return null;
    }
  }

  void _validateForm() {
    _isFormValid.value = false;//_emailError.value == null && _email != null;
  }

  @override
  void dispose() {}
}
