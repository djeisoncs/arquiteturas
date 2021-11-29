import 'dart:async';

import 'package:mocktail/mocktail.dart';

import 'package:architecture/ui/helpers/errors/errors.dart';
import 'package:architecture/ui/pages/login/login.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {
  final emailErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();
  final mainErrorController = StreamController<UIError?>();
  final navigateToController = StreamController<String?>();
  final isFormValidController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();

  LoginPresenterSpy() {
    when(() => auth()).thenAnswer((_) async => _);
    when(() => emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(() => mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(() => navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(() => isFormValidStream).thenAnswer((_) => isFormValidController.stream);
    when(() => isLoadingStream).thenAnswer((_) => isLoadingController.stream);
  }

  void emitEmailValid() => emailErrorController.add(null);

  void emitEmailError(UIError error) => emailErrorController.add(error);

  void emitPasswordValid() => passwordErrorController.add(null);

  void emitPasswordError(UIError error) => passwordErrorController.add(error);

  void emitFormValid() => isFormValidController.add(true);

  void emitFormError() => isFormValidController.add(false);

  void emitLoading([bool show = true]) => isLoadingController.add(show);

  void emitMainError(UIError error) => mainErrorController.add(error);

  void emitNavigate(String route) => navigateToController.add(route);

  void dispose() {
    emailErrorController.close();
    passwordErrorController.close();
    mainErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }
}