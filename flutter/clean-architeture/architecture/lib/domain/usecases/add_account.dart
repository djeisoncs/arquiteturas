
import 'package:equatable/equatable.dart';


import '../entities/account_entity.dart';

abstract class AddAccount {

  Future<AccountEntity> add(AddAccountParams params);
}

// ignore: must_be_immutable
class AddAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  const AddAccountParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation
  });

  @override
  List<Object> get props => [name, email, password, passwordConfirmation];
}