import 'package:architecture/modules/architecture/domain/entities/entity.dart';
import 'package:architecture/modules/architecture/domain/entities/paginator.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/domain/repositories/repository.dart';
import 'package:architecture/modules/architecture/domain/usercases/usercase.dart';
import 'package:architecture/modules/architecture/utils/util.dart';
import 'package:dartz/dartz.dart';

class UsercaseIpml<T extends Entity> implements Usercase {

  final Repository repository;


  UsercaseIpml(this.repository);

  @override
  Future<Either<Exception, List<Entity>>> call(Paginator paginator) async {
    if (isNull(paginator)) {
      return Left(ApiException());
    }

    return await repository.call(paginator);
  }

  @override
  Future<Either<Exception, void>> delete(Entity entity) async {
    if (isNull(entity)) {
      return Left(ApiException());
    }

    return await repository.delete(entity);
  }

  @override
  Future<Either<Exception, Entity>> getById(String id) async {
    if (isNullOrIsEmpity(id)) {
      return Left(ApiException());
    }

    return await repository.getById(id);
  }

  @override
  Future<Either<Exception, Entity>> save(Entity entity) async {
    if (isNull(entity)) {
      return Left(ApiException());
    }

    if (isNullOrIsEmpity(entity.id)) {
      return await repository.save(entity);
    }

    return await repository.edit(entity);
  }
}
