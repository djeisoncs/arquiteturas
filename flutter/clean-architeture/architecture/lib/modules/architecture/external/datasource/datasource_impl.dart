

import 'package:architecture/modules/architecture/data/datasources/datasource.dart';
import 'package:architecture/modules/architecture/domain/entities/entity.dart';
import 'package:architecture/modules/architecture/domain/entities/paginator.dart';
import 'package:dio/dio.dart';

class DatasourceImpl implements Datasource {

  final Dio dio;

  DatasourceImpl(this.dio);

  @override
  Future<List<Entity>> call(Paginator paginator) {
    // TODO: implement call
    throw UnimplementedError();
  }

  @override
  Future<void> delete(Entity entity) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Entity> edit(Entity entity) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<Entity> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Entity> save(Entity entity) {
    // final response = dio.post("path", data: entity);
    //
    // return Entity(id: "");
  }
  
}