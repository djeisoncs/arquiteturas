import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/entities/account_entity.dart';
import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/domain/usecases/authentication.dart';

class AuthenticationSpy extends Mock implements Authentication {
  When mockAuthenticationCall() => when(() => auth(any()));

  void mockAuthentication(AccountEntity data) => mockAuthenticationCall().thenAnswer((_) async => data);

  void mockAuthenticationError(DomainError error) => mockAuthenticationCall().thenThrow(error);
}
