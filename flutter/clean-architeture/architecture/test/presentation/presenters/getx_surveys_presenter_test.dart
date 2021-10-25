import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/usecases/usercases.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/domain_error.dart';

import 'package:architecture/ui/helpers/errors/errors.dart';
import 'package:architecture/ui/pages/pages.dart';

import 'package:architecture/presentetion/presenters/presenter.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  GetxSurveysPresenter sut;
  LoadSurveysSpy loadSurveys;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2020, 2, 20),
            didAnswer: true),
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2018, 10, 3),
            didAnswer: false)
      ];

  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError() => mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.loadData();
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
      SurveyViewModel(id: surveys[0].id, question: surveys[0].question, date: '20 Fev 2020', didAnswer: surveys[0].didAnswer),
      SurveyViewModel(id: surveys[1].id, question: surveys[1].question, date: '03 Out 2018', didAnswer: surveys[1].didAnswer),
    ])));

    await sut.loadData();
  });

  test('Should emit correct events on fails', () async {
    mockLoadSurveysError();
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

    await sut.loadData();
  });
}
