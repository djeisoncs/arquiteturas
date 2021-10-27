import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usercases.dart';
import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpAdapterDecorator(),
      url: makeApiUrl('surveys')
  );
}