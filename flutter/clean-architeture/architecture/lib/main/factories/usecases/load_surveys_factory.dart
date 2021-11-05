import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usercases.dart';
import '../../composites/composites.dart';
import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys')
);

LoadSurveys makeLocalLoadSurveys() => LocalLoadSurveys(
  cacheStorage: makeLocalStorageAdapter()
);

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() =>
    RemoteLoadSurveysWithLocalFallback(
        local: makeLocalLoadSurveys(),
        remote: makeRemoteLoadSurveys()
    );