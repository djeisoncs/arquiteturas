

import '../../../domain/usecases/usercases.dart';

class RemoteAddAccountParams {
  String name;
  String email;
  String password;
  String passwordConfirmation;

  RemoteAddAccountParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation
  });

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) =>
      RemoteAddAccountParams(
          name: params.name,
          email: params.email,
          password: params.password,
          passwordConfirmation: params.passwordConfirmation
      );

  Map toJson() => {
    "name": this.name,
    "email": this.email,
    "password": this.password,
    "passwordConfirmation": this.passwordConfirmation
  };
}