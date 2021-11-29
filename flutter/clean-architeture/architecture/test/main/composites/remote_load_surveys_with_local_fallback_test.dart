import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/main/composites/composites.dart';

import '../../domain/mocks/entity_factory.dart';
import '../../data/mocks/mocks.dart';

void main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late RemoteLoadSurveysSpy remote;
  late LocalLoadSurveysSpy local;
  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;

  setUp(() {
    remoteSurveys = EntityFactory.makeSurveyList();
    localSurveys = EntityFactory.makeSurveyList();

    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(
        remote: remote,
        local: local
    );

    remote.mockLoad(remoteSurveys);
    local.mockLoad(localSurveys);
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(() => remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(() => local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.load();

    expect(response, remoteSurveys);
  });

  test('Should rethrow if remote load throwa AcessDeniedError', () async {
    remote.mockLoadError(DomainError.accessDenied);

    expect(sut.load(), throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    remote.mockLoadError(DomainError.unexpected);

    await sut.load();

    verify(() => local.validate()).called(1);
    verify(() => local.load()).called(1);
  });

  test('Should return local surveys', () async {
    remote.mockLoadError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('Should throw Unexpected error if remote and local throws', () async {
    remote.mockLoadError(DomainError.unexpected);
    local.mockLoadError();

    expect(sut.load(), throwsA(DomainError.unexpected));
  });
}