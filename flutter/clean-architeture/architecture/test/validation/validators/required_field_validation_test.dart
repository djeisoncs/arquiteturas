import 'package:flutter_test/flutter_test.dart';

import 'package:architecture/presentation/protocols/protocols.dart';
import 'package:architecture/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Shoud return null if value is not empty', () {
    expect(sut.validate({'any_field': 'any_value'}), null);
  });

  test('Shoud return error if value is empty', () {
    expect(sut.validate({'any_field': ''}), ValidationError.requiredField);
  });

  test('Shoud return error if value is null', () {
    expect(sut.validate({'any_field': null}), ValidationError.requiredField);
  });
}