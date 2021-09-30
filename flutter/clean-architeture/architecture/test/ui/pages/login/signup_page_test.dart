import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:architecture/ui/helpers/errors/errors.dart';
import 'package:architecture/ui/pages/pages.dart';

class SignupPresenterMock extends Mock implements SignupPresenter {}

void main() {
  SignupPresenter presenter;

  StreamController<UIError> nameErrorController;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> passwordConfirmationErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void _initStreams() {
    nameErrorController = StreamController<UIError>();
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    passwordConfirmationErrorController = StreamController<UIError>();
    mainErrorController = StreamController<UIError>();
    navigateToController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void _initMocksStreams() {
    when(presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignupPresenterMock();
    _initStreams();
    _initMocksStreams();
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter)),
        GetPage(
            name: '/any_root',
            page: () => Scaffold(
                  body: Text("fake page"),
                ))
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  void _closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    mainErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }

  tearDown(() {
    _closeStreams();
  });

  testWidgets('Shold load with correct inicial state', (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(nameTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar senha'),
        matching: find.byType(Text));
    expect(passwordConfirmationTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Shold call validade with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();

    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), password);
    verify(presenter.validatePasswordConfirmation(password));
  });

  testWidgets('Shold present email error', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    emailErrorController.add(null);
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Shold present name error', (WidgetTester tester) async {
    await loadPage(tester);

    nameErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    nameErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    nameErrorController.add(null);
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel('Nome'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Shold present password error', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    passwordErrorController.add(null);
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Shold present passwordConfirmation error', (WidgetTester tester) async {
    await loadPage(tester);

    passwordConfirmationErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    passwordConfirmationErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    passwordConfirmationErrorController.add(null);
    await tester.pump();
    expect(
        find.descendant(
            of: find.bySemanticsLabel('Confirmar senha'),
            matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Shold enable button if form is valid', (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
  });

  testWidgets('Shold disable button if form is invalid', (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, null);
  });



  testWidgets('Shold call signUp on form submit', (WidgetTester tester) async {
        await loadPage(tester);
        final button = find.byType(ElevatedButton);

        isFormValidController.add(true);
        await tester.pump();
        await tester.ensureVisible(button);
        await tester.tap(button);
        await tester.pump();

        verify(presenter.signUp()).called(1);
  });

  testWidgets('Shold present loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shold hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Shold present error message if signUp fails', (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.emailInUse);
    await tester.pump();

    expect(find.text('O email já está em uso.'), findsOneWidget);
  });

  testWidgets('Shold present error message if signUp throws', (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.unexpected);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
  });

  testWidgets('Shold change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_root');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_root');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Shold not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/signup');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/signup');
  });
}
