import 'package:flutter_test/flutter_test.dart';

import 'package:architecture/validation/validators/validators.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Shoud return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('Shoud return error if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório');
  });

  test('Shoud return error if value is null', () {
    expect(sut.validate(null), 'Campo obrigatório');
  });
}