import 'package:flutter_test/flutter_test.dart';

import 'package:architecture/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('a@a.com'), null);
    expect(sut.validate('teste@gmail.com'), null);
    expect(sut.validate('teste@gmail.com.br'), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('teste'), 'Campo inválido');
    expect(sut.validate('testegmail.com'), 'Campo inválido');
  });
}