import 'package:flutter_test/flutter_test.dart';

import 'package:architecture/presentetion/protocols/validation.dart';

import 'package:architecture/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(field: 'any_field', valueToCompare: 'any_value');
  });

  test('Should return error if value is not equal', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });

  test('Should return error if value equal', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });
}