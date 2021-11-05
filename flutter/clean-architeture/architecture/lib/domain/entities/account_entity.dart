import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {

  String token;

  AccountEntity(this.token);

  @override
  List<Object> get props => [token];
}