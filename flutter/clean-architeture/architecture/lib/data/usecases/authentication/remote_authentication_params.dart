import 'package:meta/meta.dart';

import '../../../domain/usecases/authentication.dart';

class RemoteAuthenticationParams {
  String email;
  String password;

  RemoteAuthenticationParams({
    @required this.email,
    @required this.password
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(email: params.email, password: params.password);

  Map toJson() => {"email": this.email, "password": this.password};
}