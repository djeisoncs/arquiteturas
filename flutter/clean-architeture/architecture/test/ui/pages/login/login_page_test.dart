import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:architecture/ui/pages/pages.dart';
import 'package:architecture/ui/pages/login/login.dart';

class LoginPresenterMock extends Mock implements LoginPresenter {}

void main() {

  LoginPresenterMock presenter;

  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;
  StreamController<bool> isFormValidController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterMock();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(presenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
  });

  testWidgets('Shold load with correct inicial state', (WidgetTester tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text'
    );

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

    expect(passwordTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text'
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Shold call validade with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));
  });

  testWidgets('Shold present error if email is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Shold present no error if email is valid with value null', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(null);
    await tester.pump();


    expect(find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget
    );
  });

  testWidgets('Shold present no error if email is valid with value is empty', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('');
    await tester.pump();


    expect(find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget
    );
  });

  testWidgets('Shold present error if password is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Shold present no error if password is valid with value null', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(null);
    await tester.pump();

    expect(find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget
    );
  });

  testWidgets('Shold present no error if password is valid with value is empty', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add('');
    await tester.pump();

    expect(find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget
    );
  });

  testWidgets('Shold enable button if form is valid', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Shold enable button if form is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });
}
