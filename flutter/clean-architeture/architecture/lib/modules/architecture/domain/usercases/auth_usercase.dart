
import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:dartz/dartz.dart';

abstract class AuthUsercase<T> {

  Future<Either<Exception, Usuario>> signIn(String username, String password);

  Future<Either<Exception, void>> signOut(String username, String password);

  Future<Either<Exception, T>> getCurrentUser();

  Future<Either<Exception, void>> clearCurrentUser();


}