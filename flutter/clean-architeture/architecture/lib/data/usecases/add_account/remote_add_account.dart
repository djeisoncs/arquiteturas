import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/add_account.dart';

import '../../http/http.dart';
import '../../models/models.dart';

import 'remote_add_account_params.dart';


class RemoteAddAccount {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  Future<void> add(AddAccountParams params) async {
    final body = RemoteAddAccountParams.fromDomain(params).toJson();

    try {
      await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError catch(error) {
      throw error == HttpError.forbidden
          ? DomainError.emailInUse
          :DomainError.unexpected;
    }
  }

}