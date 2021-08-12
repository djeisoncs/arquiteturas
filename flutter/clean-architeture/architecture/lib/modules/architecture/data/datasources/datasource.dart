

import 'package:architecture/modules/architecture/domain/entities/entity.dart';
import 'package:architecture/modules/architecture/domain/entities/paginator.dart';

abstract class Datasource<T extends Entity> {

  Future<List<T>> call(Paginator paginator);

  Future<T> getById(String id);

  Future<T> save(T entity);

  Future<T> edit(T entity);

  Future<void> delete(T entity);
}