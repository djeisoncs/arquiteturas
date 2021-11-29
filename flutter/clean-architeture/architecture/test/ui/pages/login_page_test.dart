import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:architecture/ui/helpers/errors/errors.dart';
import 'package:architecture/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import '../mocks/login_presenter_spy.dart';

void main() {
  late LoginPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();

    await tester.pumpWidget(makePage(path: '/login', page: () => LoginPage(presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Shold call validade with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));
  });

  testWidgets('Shold present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);
  });


  testWidgets('Shold present error if email is empty',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('Shold present no error if email is valid with value null',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailValid();
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Shold present error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordError(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('Shold present no error if password is valid with value null',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordValid();
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Shold enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormValid();
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton ));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Shold disable button if form is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormError();
    await tester.pump();

    final button = tester.widget<ElevatedButton >(find.byType(ElevatedButton ));
    expect(button.onPressed, null);
  });

  testWidgets('Shold call authentication on form submit',
      (WidgetTester tester) async {
    await loadPage(tester);
    final button = find.byType(ElevatedButton );

    presenter.emitFormValid();
    await tester.pump();
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.auth()).called(1);
  });

  testWidgets('Shold handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    presenter.emitLoading(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);


    presenter.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shold present error message if authentication fails', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.invalidCredentials);
    await tester.pump();

    expect(find.text('Credenciais inválidas.'), findsOneWidget);
  });

  testWidgets('Shold present error message if authentication throws', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.unexpected);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
  });

  testWidgets('Shold change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigate('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Shold not change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigate('');
    await tester.pump();
    expect(currentRoute, '/login');
  });

  testWidgets('Shold call gotoSignUp on link click', (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.text('Criar conta');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.goToSignUp()).called(1);
  });
}
