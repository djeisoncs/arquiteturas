

import 'package:architecture/modules/architecture/domain/entities/post.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/domain/repositories/post_repository.dart';
import 'package:architecture/modules/architecture/domain/usercases/post_usercase.dart';
import 'package:architecture/modules/architecture/utils/util.dart';
import 'package:dartz/dartz.dart';

class PostUsercaseImpl implements PostUsercase {

  final PostRepository repository;

  PostUsercaseImpl(this.repository);

  @override
  Future<Either<AppException, List<Post>>> call(int id) async {

    if (isNull(id)) {
      return Left(ApiException());
    }
    return await repository.call(id);
  }

}