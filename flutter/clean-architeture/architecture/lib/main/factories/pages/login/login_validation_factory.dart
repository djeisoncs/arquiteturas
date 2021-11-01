import '../../../../validation/protocols/protocols.dart';
import '../../../../presentetion/protocols/protocols.dart';
import '../../../composites/composites.dart';
import '../../../builders/builders.dart';

Validation makeLoginValidation() => ValidationComposite(makeLoginValidations());

List<FieldValidation> makeLoginValidations() => [
    ... ValidationBuilder.field('email').required().email().build(),
    ... ValidationBuilder.field('password').required().min(3).build()
  ];