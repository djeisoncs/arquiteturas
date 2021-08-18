
import 'package:architecture/modules/architecture/domain/entities/post.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:dartz/dartz.dart';

abstract class PostUsercase {

  Future<Either<AppException, List<Post>>> call(int id);
}