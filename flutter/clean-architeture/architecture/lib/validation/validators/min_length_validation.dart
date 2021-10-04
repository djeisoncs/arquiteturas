import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentetion/protocols/protocols.dart';

import '../protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation  {
  final String field;
  final int size;

  MinLengthValidation({@required this.field, @required this.size});

  @override
  ValidationError validate(Map input) => input[field] != null && input[field].length >= size ? null : ValidationError.invalidField;


  @override
  List<Object> get props => [field, size];
}