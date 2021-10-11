import 'package:flutter_test/flutter_test.dart';
import 'package:architecture/main/factories/factories.dart';
import 'package:architecture/validation/validators/validators.dart';


void main() {
  test('Should return the correct validations', () {
    final validations = makeSignupValidations();

    expect(validations, [
      RequiredFieldValidation('name'),
      MinLengthValidation(field: 'name', size: 3),
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', size: 3),
      RequiredFieldValidation('passwordConfirmation'),
      CompareFieldsValidation(field: 'passwordConfirmation', fieldToCompare: 'password')
    ]);
  });
}