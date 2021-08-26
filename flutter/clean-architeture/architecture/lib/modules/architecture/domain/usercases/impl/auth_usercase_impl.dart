
import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/domain/repositories/auth_repository.dart';
import 'package:architecture/modules/architecture/utils/util.dart';

import 'package:dartz/dartz.dart';

import '../auth_usercase.dart';

class AuthUsercaseImpl implements AuthUsercase {

  final AuthRepository repository;

  AuthUsercaseImpl(this.repository);

  @override
  Future<Either<Exception, Usuario>> auth(String username, String password) async {

    if (isNullOrIsEmpity(username) || isNullOrIsEmpity(password)) {
      return Left(AppError());
    }

    return repository.auth(username, password);
  }
  
}