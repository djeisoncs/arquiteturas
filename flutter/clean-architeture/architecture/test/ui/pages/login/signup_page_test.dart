import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:architecture/ui/helpers/errors/errors.dart';
import 'package:architecture/ui/pages/pages.dart';

class LoginPresenterMock extends Mock implements SingnupPresenter {}

void main() {
  LoginPresenterMock presenter;

  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void _initStreams() {
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    mainErrorController = StreamController<UIError>();
    navigateToController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void _initMocksStreams() {
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
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
    presenter = LoginPresenterMock();
    _initStreams();
    _initMocksStreams();
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
        getPages: [
          GetPage(name: '/signup', page: () => SignUpPage(presenter)),
          GetPage(name: '/any_root', page: () => Scaffold(body: Text("fake page"),))
        ],
    );
    await tester.pumpWidget(signUpPage);
  }

  void _closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    mainErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }

  tearDown(() {
    _closeStreams();
  });

  testWidgets('Shold load with correct inicial state',
      (WidgetTester tester) async {
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
        of: find.bySemanticsLabel('Confirmar Senha'), matching: find.byType(Text));

    expect(passwordConfirmationTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
