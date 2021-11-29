import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/entities/account_entity.dart';
import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/domain/usecases/add_account.dart';

class AddAccountSpy extends Mock implements AddAccount {
  When mockAddAccountCall() => when(() => add(any()));

  void mockAddAccount(AccountEntity data) => mockAddAccountCall().thenAnswer((_) async => data);

  void mockAddAccountError(DomainError error) => mockAddAccountCall().thenThrow(error);
}