import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/usecases/usercases.dart';
import 'package:architecture/ui/pages/pages.dart';

class GetxSurveysPresenter /*implements SurveysPresenter*/ {
  final LoadSurveys loadSurveys;
  GetxSurveysPresenter({@required this.loadSurveys}); // @override
  // Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  Future<void> loadData() async {
    await loadSurveys.load();
  }

  // @override
  // Stream<List<SurveyViewModel>> get loadSurveysStream => throw UnimplementedError();

}
class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {

  GetxSurveysPresenter sut;
  LoadSurveysSpy loadSurveys;

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

  });

  test('Shoul call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });
}