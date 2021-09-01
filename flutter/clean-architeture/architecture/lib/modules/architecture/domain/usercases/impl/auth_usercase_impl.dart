
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
  Future<Either<Exception, Usuario>> signIn(String username, String password) async {

    if (isNullOrIsEmpity(username) || isNullOrIsEmpity(password)) {
      return Left(AppError());
    }

    return repository.auth(username, password);
  }

  @override
  Future<Either<Exception, void>> signOut(String username, String password) {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> clearCurrentUser() {
    // TODO: implement clearCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, dynamic>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
  
}