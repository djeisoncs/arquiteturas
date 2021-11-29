import 'package:architecture/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late SplashPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();

    await tester.pumpWidget(makePage(path: '/', page: () => SplashPage(presenter: presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Shold present spinner on page load', (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shold call loadCurrentAccont on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.checkAccont()).called(1);
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
    expect(currentRoute, '/');
  });
}