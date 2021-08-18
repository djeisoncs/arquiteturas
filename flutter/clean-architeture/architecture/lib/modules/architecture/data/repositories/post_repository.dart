
import 'package:architecture/modules/architecture/data/datasources/post_datasource.dart';
import 'package:architecture/modules/architecture/domain/entities/post.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';

class PostRepositoryImpl implements PostRepository {

  final PostDatasource datasource;

  PostRepositoryImpl(this.datasource);

  @override
  Future<Either<AppException, List<Post>>> call(int id) async {
    try {
      final result = await datasource.call(id);

      return Right(result);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException());
    }
  }

}