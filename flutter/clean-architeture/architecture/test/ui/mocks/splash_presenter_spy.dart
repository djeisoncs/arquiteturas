import 'dart:async';

import 'package:architecture/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {
  final navigateToController = StreamController<String?>();

  SplashPresenterSpy() {
    when(() => checkAccont(durationInSeconds: any(named: 'durationInSeconds'))).thenAnswer((_) async => _);
    when(() => navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  void emitNavigate(String route) => navigateToController.add(route);

  void dispose() {
    navigateToController.close();
  }
}