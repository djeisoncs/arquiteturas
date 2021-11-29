import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usercases.dart';
import '../../composites/composites.dart';
import '../factories.dart';

RemoteLoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) => RemoteLoadSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys/$surveyId/results')
);

LocalLoadSurveyResult makeLocalLoadSurveyResult(String surveyId) => LocalLoadSurveyResult(
    cacheStorage: makeLocalStorageAdapter()
);

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) => RemoteLoadSurveyResultWithLocalFallBack(
    remote: makeRemoteLoadSurveyResult(surveyId),
    local: makeLocalLoadSurveyResult(surveyId)
);