import 'package:flutter_test/flutter_test.dart';
import 'package:architecture/main/factories/factories.dart';
import 'package:architecture/validation/validators/validators.dart';


void main() {
  test('Should return the correct validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password')
    ]);
  });
}