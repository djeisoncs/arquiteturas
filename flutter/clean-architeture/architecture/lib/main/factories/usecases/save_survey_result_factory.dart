import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usercases.dart';
import '../../composites/composites.dart';
import '../factories.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) => RemoteSaveSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys/$surveyId/results')
);
