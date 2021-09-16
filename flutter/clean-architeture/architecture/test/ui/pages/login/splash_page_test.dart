import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  SplashPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccont();

    return Scaffold(
      appBar: AppBar(title: Text('4Dev'),),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}

abstract class SplashPresenter {
  Future<void> loadCurrentAccont();
}

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  SplashPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => SplashPage(presenter: presenter))
          ],
        )
    );
  }

  testWidgets('Shold present spinner on page load', (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Shold call loadCurrentAccont on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadCurrentAccont()).called(1);
  });
}