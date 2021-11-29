import 'package:mocktail/mocktail.dart';

import 'package:architecture/presentation/protocols/protocols.dart';
import 'package:architecture/validation/protocols/filed_validation.dart';

class FieldValidationSpy extends Mock implements FieldValidation {
  FieldValidationSpy() {
    mockValidation();
    mockFieldName('any_field');
  }

  When mockValidationCall() => when(() => validate(any()));
  void mockValidationError(ValidationError error) => mockValidationCall().thenReturn(error);
  void mockValidation() => mockValidationCall().thenReturn(null);

  void mockFieldName(String fieldName) => when(() => field).thenReturn(fieldName);
}