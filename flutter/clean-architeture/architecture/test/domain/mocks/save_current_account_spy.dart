import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/domain/usecases/save_current_account.dart';

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {

  SaveCurrentAccountSpy() {
    mockSaveCurrentAccount();
  }

  When mockSaveCurrentAccountCall() => when(() => save(any()));

  void mockSaveCurrentAccount() => mockSaveCurrentAccountCall().thenAnswer((_) async => _);

  void mockSaveCurrentAccountError() => mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
}