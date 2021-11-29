import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/main/composites/composites.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/entity_factory.dart';

void main() {
  late RemoteLoadSurveyResultWithLocalFallBack sut;
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResultSpy local;
  late String surveyId;
  late SurveyResultEntity remoteResult;
  late SurveyResultEntity localResult;

  setUp(() {
    surveyId = faker.guid.guid();
    remoteResult = EntityFactory.makeSurveyResult();
    localResult = EntityFactory.makeSurveyResult();

    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();

    sut = RemoteLoadSurveyResultWithLocalFallBack(remote: remote, local: local);

    remote.mockLoadBySurvey(remoteResult);
    local.mockLoadBySurvey(localResult);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSurveyResult());
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(remoteResult)).called(1);
  });

  test('Should call return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteResult);
  });

  test('Should rethrow if remote loadBySurvey throws AccessDeniedError', () async {
    remote.mockLoadBySurveyError(DomainError.accessDenied);

    expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.accessDenied));
  });

  test('Should call local LoadBySurvey on remote error', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call return local data', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localResult);
  });

  test('Should throw UnexpectedError if local load fails', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);
    local.mockLoadBySurveyError();

    expect(sut.loadBySurvey(surveyId: surveyId), throwsA(DomainError.unexpected));
  });
}
