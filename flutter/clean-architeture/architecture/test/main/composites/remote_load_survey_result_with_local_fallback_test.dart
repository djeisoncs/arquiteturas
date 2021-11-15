import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:architecture/data/usecases/load_survey_result/load_survey_result.dart';
import 'package:architecture/domain/entities/survey_result_entity.dart';
import 'package:architecture/domain/usecases/load_survey_result.dart';

class RemoteLoadSurveyResultWithLocalFallBack /*implements LoadSurveyResult*/ {
  final RemoteLoadSurveyResult remote;

  RemoteLoadSurveyResultWithLocalFallBack({@required this.remote});

  @override
  // Future<SurveyResultEntity> loadBySurvey({String surveyId}) {
  Future<void> loadBySurvey({String surveyId}) async {
    await remote.loadBySurvey(surveyId: surveyId);
  }

}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultWithLocalFallBack sut;
  RemoteLoadSurveyResultSpy remote;
  String surveyId;

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallBack(
      remote: remote
    );
  });

  test('Should call remot LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });
}