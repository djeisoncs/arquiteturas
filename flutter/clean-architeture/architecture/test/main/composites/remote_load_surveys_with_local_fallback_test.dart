import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/data/usecases/load_surveys/load_surveys.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:architecture/main/composites/composites.dart';


class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveysSpy remote;
  LocalLoadSurveysSpy local;
  List<SurveyEntity> remoteSurveys;
  List<SurveyEntity> localSurveys;

  List<SurveyEntity> mockSurveys() => [
    SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(50),
        dateTime: faker.date.dateTime(),
        didAnswer: faker.randomGenerator.boolean()
    )
  ];

  PostExpectation mockRemoteLoadCall() => when(remote.load());
  
  void mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);


  PostExpectation mockLocalLoadCall() => when(local.load());

  void mockLocalLoad() {
    localSurveys = mockSurveys();
    mockLocalLoadCall().thenAnswer((_) async => localSurveys);
  }

  void mockLocalLoadError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(
        remote: remote,
        local: local
    );

    mockRemoteLoad();

    mockLocalLoad();
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.load();

    expect(response, remoteSurveys);
  });

  test('Should rethrow if remote load throwa AcessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);

    expect(sut.load(), throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.load();

    verify(local.validate()).called(1);
    verify(local.load()).called(1);
  });

  test('Should return local surveys', () async {
    mockRemoteLoadError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('Should throw Unexpected error if remote and local throws', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

    expect(sut.load(), throwsA(DomainError.unexpected));
  });
}