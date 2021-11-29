


import '../../../domain/usecases/authentication.dart';
import '../../../domain/entities/account_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';

import '../../models/models.dart';
import './remote_authentication_params.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final response = await httpClient.request(url: url,
          method: "post",
          body: RemoteAuthenticationParams.fromDomain(params).toJson());

      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch(error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          :DomainError.unexpected;
    }
  }

}