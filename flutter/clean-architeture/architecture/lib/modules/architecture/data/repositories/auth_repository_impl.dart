
import 'package:architecture/modules/architecture/data/datasources/auth_datasource.dart';
import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<Either<Exception, Usuario>> auth(String username, String password) async {
    try {
      return Right(await datasource.auth(username, password));
    } on ApiException catch(e) {
      return Left(AppError(msg: e.msg));
    } catch(e) {
      return Left(AppError());
    }
  }

}