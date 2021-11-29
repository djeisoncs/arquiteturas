import 'package:mocktail/mocktail.dart';

import 'package:architecture/domain/entities/account_entity.dart';
import 'package:architecture/domain/usecases/load_current_account.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
  When mockLoadCall() => when(() => load());

  void mockLoad({required AccountEntity account}) => mockLoadCall().thenAnswer((_) async => account);

  void mockLoadError() => mockLoadCall().thenThrow(Exception());
}