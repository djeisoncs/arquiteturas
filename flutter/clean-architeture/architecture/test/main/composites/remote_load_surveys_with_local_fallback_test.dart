import 'package:architecture/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/data/usecases/load_surveys/load_surveys.dart';
import 'package:architecture/domain/entities/entities.dart';
import 'package:architecture/domain/usecases/usercases.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
    @required this.local
  });

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await remote.load();

      await local.save(surveys);

      return surveys;
    } catch(error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }

      await local.validate();

      await local.load();
    }
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveysSpy remote;
  LocalLoadSurveysSpy local;
  List<SurveyEntity> surveys;

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
    surveys = mockSurveys();
    mockRemoteLoadCall().thenAnswer((_) async => surveys);
  }

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(
        remote: remote,
        local: local
    );

    mockRemoteLoad();
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(local.save(surveys)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.load();

    expect(response, surveys);
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
}