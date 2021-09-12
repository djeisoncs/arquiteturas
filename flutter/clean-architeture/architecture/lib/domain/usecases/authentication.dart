
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/account_entity.dart';

abstract class Authentication {

  Future<AccountEntity> auth(AuthenticationParams params);
}

// ignore: must_be_immutable
class AuthenticationParams extends Equatable {
  String email;
  String password;

  AuthenticationParams({@required String email, @required String password});

  @override
  List<Object> get props => [email, password];
}