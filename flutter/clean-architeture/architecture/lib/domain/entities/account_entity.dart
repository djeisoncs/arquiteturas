import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {

  String token;

  AccountEntity({required this.token});

  @override
  List<Object> get props => [token];
}