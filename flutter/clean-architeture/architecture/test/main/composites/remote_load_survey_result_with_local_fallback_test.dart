import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/data/usecases/usecases.dart';
import 'package:architecture/main/composites/composites.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultWithLocalFallBack sut;
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  String surveyId;
  SurveyResultEntity remoteResult;
  SurveyResultEntity localResult;

  SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
                answer: faker.lorem.sentence(),
                isCurrentAnswer: faker.randomGenerator.boolean(),
                percent: faker.randomGenerator.integer(100))
          ]);

  PostExpectation mockRemoteCall() => when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  PostExpectation mockLocalLoadCall() => when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoad() {
    remoteResult = mockSurveyResult();
    mockRemoteCall().thenAnswer((_) async => remoteResult);
  }

  void mockLocalLoad() {
    localResult = mockSurveyResult();
    mockLocalLoadCall().thenAnswer((_) async => localResult);
  }

  void mockRemoteError(DomainError error) => mockRemoteCall().thenThrow(error);

  void mockLocalError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    surveyId = faker.guid.guid();

    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();

    sut = RemoteLoadSurveyResultWithLocalFallBack(remote: remote, local: local);

    mockRemoteLoad();
    mockLocalLoad();
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyId: surveyId, surveyResult: remoteResult)).called(1);
  });

  test('Should call return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteResult);
  });

  test('Should rethrow if remote loadBySurvey throws AccessDeniedError', () async {
    mockRemoteError(DomainError.accessDenied);

    expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.accessDenied));
  });

  test('Should call local LoadBySurvey on remote error', () async {
    mockRemoteError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call return local data', () async {
    mockRemoteError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localResult);
  });

  test('Should throw UnexpectedError if local load fails', () async {
    mockRemoteError(DomainError.unexpected);
    mockLocalError();

    expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
  });
}
