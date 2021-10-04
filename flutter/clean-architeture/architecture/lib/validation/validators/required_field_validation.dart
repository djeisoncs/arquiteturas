import 'package:equatable/equatable.dart';

import '../../presentetion/protocols/protocols.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  @override
  List<Object> get props => [field];

  RequiredFieldValidation(this.field);

  @override
  ValidationError validate(Map input) => input[field]?.isNotEmpty == true ? null : ValidationError.requiredField;

}