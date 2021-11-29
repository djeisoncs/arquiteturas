import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:architecture/ui/helpers/errors/errors.dart';
import 'package:architecture/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late SignupPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignupPresenterSpy();

    await tester.pumpWidget(makePage(path: '/signup', page: () => SignUpPage(presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Shold call validade with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(() => presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();

    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), password);
    verify(() => presenter.validatePasswordConfirmation(password));
  });

  testWidgets('Shold present email error', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    presenter.emitEmailError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    presenter.emitEmailValid();
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Shold present name error', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNameError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    presenter.emitNameError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    presenter.emitNameValid();
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel('Nome'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Shold present password error', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    presenter.emitPasswordError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    presenter.emitPasswordValid();
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Shold present passwordConfirmation error', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordConfirmationError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    presenter.emitPasswordConfirmationError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    presenter.emitPasswordConfirmationValid();
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel('Confirmar senha'),
            matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Shold enable button if form is valid', (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitFormValid();
      await tester.pump();

      final button = tester.widget<ElevatedButton >(find.byType(ElevatedButton ));
      expect(button.onPressed, isNotNull);
  });

  testWidgets('Shold disable button if form is invalid', (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitFormError();
      await tester.pump();

      final button = tester.widget<ElevatedButton >(find.byType(ElevatedButton ));
      expect(button.onPressed, null);
  });



  testWidgets('Shold call signUp on form submit', (WidgetTester tester) async {
        await loadPage(tester);
        final button = find.byType(ElevatedButton );

        presenter.emitFormValid();
        await tester.pump();
        await tester.ensureVisible(button);
        await tester.tap(button);
        await tester.pump();

        verify(() => presenter.signUp()).called(1);
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

  testWidgets('Shold present error message if signUp fails', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.emailInUse);
    await tester.pump();

    expect(find.text('O email já está em uso.'), findsOneWidget);
  });

  testWidgets('Shold present error message if signUp throws', (WidgetTester tester) async {
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
    expect(currentRoute, '/signup');
  });

  testWidgets('Shold call gotoLogin on link click', (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.text('Login');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.goToLogin()).called(1);
  });
}
