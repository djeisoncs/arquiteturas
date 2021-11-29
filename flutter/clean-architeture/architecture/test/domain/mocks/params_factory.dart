import 'package:faker/faker.dart';

import 'package:architecture/domain/usecases/usercases.dart';

class ParamsFactory {

  static AddAccountParams makeAddAccount() => AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password()
  );

  static AuthenticationParams makeAuthentication() => AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password()
  );
}