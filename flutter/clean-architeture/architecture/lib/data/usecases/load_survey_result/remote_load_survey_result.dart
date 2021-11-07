import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usercases.dart';

import '../../models/models.dart';
import '../../http/http.dart';

class RemoteLoadSurveyResult implements LoadSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveyResult({@required this.url, @required this.httpClient});

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final httpResponse = await httpClient.request(url: url, method: 'get');

      return RemoteSurveyResultModel.fromJson(httpResponse).toEntity();
    } on HttpError catch(error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}