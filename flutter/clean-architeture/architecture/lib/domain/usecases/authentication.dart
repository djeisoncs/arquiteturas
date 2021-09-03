
import 'package:meta/meta.dart';

import '../entities/account_entity.dart';

abstract class Authentication {

  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  String email;
  String password;

  AuthenticationParams({@required String email, @required String password});
}