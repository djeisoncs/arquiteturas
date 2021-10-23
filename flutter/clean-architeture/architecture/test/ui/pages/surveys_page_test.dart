import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:architecture/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter))
      ],
    );
    await tester.pumpWidget(surveysPage);
  }


  testWidgets('Should call LoadSurveys on page load', (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  // testWidgets('Shold handle loading correctly', (WidgetTester tester) async {
  //   await loadPage(tester);
  //
  //   isLoadingController.add(true);
  //   await tester.pump();
  //
  //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
  // });

  // testWidgets('Shold hide loading', (WidgetTester tester) async {
  //   await loadPage(tester);
  //
  //   isLoadingController.add(true);
  //   await tester.pump();
  //   isLoadingController.add(false);
  //   await tester.pump();
  //
  //   expect(find.byType(CircularProgressIndicator), findsNothing);
  // });
}