import '../../../../validation/protocols/protocols.dart';
import '../../../../presentation/protocols/protocols.dart';
import '../../../composites/composites.dart';
import '../../../builders/builders.dart';

Validation makeSignupValidation() => ValidationComposite(makeSignupValidations());

List<FieldValidation> makeSignupValidations() => [
    ... ValidationBuilder.field('name').required().min(3).build(),
    ... ValidationBuilder.field('email').required().email().build(),
    ... ValidationBuilder.field('password').required().min(3).build(),
    ... ValidationBuilder.field('passwordConfirmation').required().someAs('password').build()
  ];