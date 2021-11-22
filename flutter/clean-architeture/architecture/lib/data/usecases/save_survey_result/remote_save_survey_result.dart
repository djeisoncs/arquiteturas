import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usercases.dart';

import '../../models/models.dart';
import '../../http/http.dart';

class RemoteSaveSurveyResult /*implements SaveSurveyResult*/ {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({@required this.url, @required this.httpClient});

  Future<void> save({@required String answer}) async {
  // Future<SurveyResultEntity> save({@required String answer}) async {
    try {
      await httpClient.request(url: url, method: 'put', body: {'answer':answer});
      // final httpResponse = await httpClient.request(url: url, method: 'put', body: {});

    } on HttpError catch(error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}