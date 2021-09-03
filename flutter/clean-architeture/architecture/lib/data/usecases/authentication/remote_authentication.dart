
import './remote_authentication_params.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/authentication.dart';
import '../../../domain/helpers/helpers.dart';

import '../../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<void> auth(AuthenticationParams params) async {
    try {
      await httpClient.request(url: url,
          method: "post",
          body: RemoteAuthenticationParams.fromDomain(params).toJson());
    } on HttpError {
      throw DomainError.unexpected;
    }
  }

}