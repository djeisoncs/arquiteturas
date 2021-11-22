import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/usecases/usercases.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/domain_error.dart';

import 'package:architecture/ui/helpers/errors/errors.dart';
import 'package:architecture/ui/pages/pages.dart';

import 'package:architecture/presentation/presenters/presenter.dart';

class LoadSurveyResltSpy extends Mock implements LoadSurveyResult {}
class SaveSurveyResltSpy extends Mock implements SaveSurveyResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveyResltSpy loadSurveyResult;
  SaveSurveyResltSpy saveSurveyResult;
  SurveyResultEntity loadResult;
  SurveyResultEntity saveResult;
  String surveyId;
  String answer;

  SurveyResultEntity mockValidData() =>
      SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
                image: faker.internet.httpsUrl(),
                answer: faker.lorem.sentence(),
                isCurrentAnswer: faker.randomGenerator.boolean(),
                percent: faker.randomGenerator.integer(100)
            ),
            SurveyAnswerEntity(
                answer: faker.lorem.sentence(),
                isCurrentAnswer: faker.randomGenerator.boolean(),
                percent: faker.randomGenerator.integer(100)
            )
          ]
      );

  PostExpectation mockLoadSurveyResultCall() => when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => loadResult);
  }

  void mockLoadSurveyResultError(DomainError error) => mockLoadSurveyResultCall().thenThrow(error);

  PostExpectation mockSaveSurveyResultCall() => when(saveSurveyResult.save(answer: anyNamed('answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

  void mockSaveSurveyResultError(DomainError error) => mockSaveSurveyResultCall().thenThrow(error);

  setUp(() {
    surveyId = faker.guid.guid();
    answer = faker.lorem.sentence();
    loadSurveyResult = LoadSurveyResltSpy();
    saveSurveyResult = SaveSurveyResltSpy();
    sut = GetxSurveyResultPresenter(
        loadSurveyResult: loadSurveyResult,
        saveSurveyResult: saveSurveyResult,
        surveyId: surveyId
    );
    mockLoadSurveyResult(mockValidData());
    mockSaveSurveyResult(mockValidData());
  });

  group('loadData', () {
    test('Should call LoadSurveyResult on loadData', () async {
      await sut.loadData();

      verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.surveyResultStream.listen(expectAsync1((result) => expect(result, SurveyResultViewModel(
          surveyId: loadResult.surveyId,
          question: loadResult.question,
          answers: [
            SurveyAnswerViewModel(
                image: loadResult.answers[0].image,
                answer: loadResult.answers[0].answer,
                isCurrentAnswer: loadResult.answers[0].isCurrentAnswer,
                percent: '${loadResult.answers[0].percent}%'
            ),
            SurveyAnswerViewModel(
                answer: loadResult.answers[1].answer,
                isCurrentAnswer: loadResult.answers[1].isCurrentAnswer,
                percent: '${loadResult.answers[1].percent}%'
            ),
          ])
      )));

      await sut.loadData();
    });

    test('Should emit correct events on failure', () async {
      mockLoadSurveyResultError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.surveyResultStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

      await sut.loadData();
    });

    test('Should emit correct events on access denied', () async {
      mockLoadSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });
  });

  group('save', () {
    test('Should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);

      verify(saveSurveyResult.save(answer: answer)).called(1);
    });

    test('Should emit correct events on success group save', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.surveyResultStream.listen(expectAsync1((result) => expect(result, SurveyResultViewModel(
          surveyId: saveResult.surveyId,
          question: saveResult.question,
          answers: [
            SurveyAnswerViewModel(
                image: saveResult.answers[0].image,
                answer: saveResult.answers[0].answer,
                isCurrentAnswer: saveResult.answers[0].isCurrentAnswer,
                percent: '${saveResult.answers[0].percent}%'
            ),
            SurveyAnswerViewModel(
                answer: saveResult.answers[1].answer,
                isCurrentAnswer: saveResult.answers[1].isCurrentAnswer,
                percent: '${saveResult.answers[1].percent}%'
            ),
          ])
      )));

      await sut.save(answer: answer);
    });

    test('Should emit correct events on failure group save', () async {
      mockSaveSurveyResultError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.surveyResultStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

      await sut.save(answer: answer);
    });

    test('Should emit correct events on access denied group save', () async {
      mockSaveSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });

  });
}
