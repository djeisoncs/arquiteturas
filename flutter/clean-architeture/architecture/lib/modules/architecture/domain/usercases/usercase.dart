
import 'package:architecture/modules/architecture/domain/entities/entity.dart';
import 'package:architecture/modules/architecture/domain/entities/paginator.dart';
import 'package:dartz/dartz.dart';

abstract class Usercase<T extends Entity> {

  Future<Either<Exception, List<T>>> call(Paginator paginator);

  Future<Either<Exception, T>> getById(String id);

  Future<Either<Exception, T>> save(T entity);

  Future<Either<Exception, void>> delete(T entity);
}