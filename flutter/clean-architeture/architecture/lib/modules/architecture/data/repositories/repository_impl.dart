
import 'package:architecture/modules/architecture/data/datasources/datasource.dart';
import 'package:architecture/modules/architecture/domain/entities/entity.dart';
import 'package:architecture/modules/architecture/domain/entities/paginator.dart';
import 'package:architecture/modules/architecture/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl<T extends Entity> implements Repository<T> {

  final Datasource datasource;

  RepositoryImpl(this.datasource);

  @override
  Future<Either<Exception, List<T>>> call(Paginator paginator) {
    // TODO: implement call
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, void>> delete(T entity) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, T>> edit(T entity) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, T>> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, T>> save(T entity) {
    // TODO: implement save
    throw UnimplementedError();
  }


}