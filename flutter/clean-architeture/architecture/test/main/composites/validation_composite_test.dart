import 'package:flutter_test/flutter_test.dart';

import 'package:architecture/presentation/protocols/protocols.dart';
import 'package:architecture/main/composites/composites.dart';

import '../../validation/mocks/field_validation_spy.dart';

void main() {
  late ValidationComposite sut;
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;

  setUp(() {
    validation1 = FieldValidationSpy();
    validation2 = FieldValidationSpy();
    validation3 = FieldValidationSpy();

    validation1.mockFieldName('other_field');

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validations returns null or empty', () {
    expect(sut.validate(field: 'any_field', input: {}), null);
  });

  test('Should return the first error', () {
    validation1.mockValidationError(ValidationError.invalidField);
    validation2.mockValidationError(ValidationError.requiredField);
    validation3.mockValidationError(ValidationError.invalidField);

    expect(sut.validate(field: 'any_field', input: {}), ValidationError.requiredField);
  });
}