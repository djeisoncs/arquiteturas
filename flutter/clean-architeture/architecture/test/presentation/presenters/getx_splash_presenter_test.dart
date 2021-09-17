import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/usecases/load_current_account.dart';

import 'package:architecture/presentetion/presenters/presenter.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccountSpy loadCurrentAccount;
  GetxSplashPresenter sut;

  PostExpectation mockLoadCurrentAccountCall() => when(loadCurrentAccount.load());

  void mockLoadCurrentAccount({AccountEntity account}) =>
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);

  void mockLoadCurrentError({AccountEntity account}) =>
    mockLoadCurrentAccountCall().thenThrow(Exception());


  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: AccountEntity(faker.guid.guid()));
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccont();

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on sucess', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccont();
  });

  test('Should go to login page on sucess on null result', () async {
    mockLoadCurrentAccount(account: null);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccont();
  });

  test('Should go to login page on error', () async {
    mockLoadCurrentError();

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccont();
  });
}