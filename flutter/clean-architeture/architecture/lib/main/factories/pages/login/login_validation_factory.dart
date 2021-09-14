import '../../../../validation/protocols/protocols.dart';
import '../../../../presentetion/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../builders/builders.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ... ValidationBuilder.field('email').required().email().build(),
    ... ValidationBuilder.field('password').required().build()
  ];
}