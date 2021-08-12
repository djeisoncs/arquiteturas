

import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Exception, Usuario>> auth(String username, String password);
}