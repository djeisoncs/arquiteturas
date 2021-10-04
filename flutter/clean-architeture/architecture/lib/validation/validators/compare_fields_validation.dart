import 'package:meta/meta.dart';

import '../../presentetion/protocols/protocols.dart';

import '../protocols/protocols.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldsValidation({@required this.field, @required this.fieldToCompare});

  @override
  ValidationError validate(Map input) => input[field] == input[fieldToCompare] ? null : ValidationError.invalidField;
}