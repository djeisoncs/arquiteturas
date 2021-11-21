import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:architecture/data/usecases/usecases.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/usecases/usercases.dart';

class RemoteLoadSurveyResultWithLocalFallBack implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallBack(
      {@required this.remote, @required this.local});

  @override
  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final surveyResult = await remote.loadBySurvey(surveyId: surveyId);
      local.save(surveyId: surveyId, surveyResult: surveyResult);

      return surveyResult;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }

      await local.validate(surveyId);
      await local.loadBySurvey(surveyId: surveyId);
    }
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultWithLocalFallBack sut;
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  String surveyId;
  SurveyResultEntity surveyResult;

  SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
                answer: faker.lorem.sentence(),
                isCurrentAnswer: faker.randomGenerator.boolean(),
                percent: faker.randomGenerator.integer(100))
          ]);

  PostExpectation mockRemoteCall() =>
      when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoad() {
    surveyResult = mockSurveyResult();
    mockRemoteCall().thenAnswer((_) async => surveyResult);
  }

  void mockRemoteError(DomainError error) => mockRemoteCall().thenThrow(error);

  setUp(() {
    surveyId = faker.guid.guid();

    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();

    sut = RemoteLoadSurveyResultWithLocalFallBack(remote: remote, local: local);

    mockRemoteLoad();
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyId: surveyId, surveyResult: surveyResult)).called(1);
  });

  test('Should call return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, surveyResult);
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
}
