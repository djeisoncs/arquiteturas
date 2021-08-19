import 'package:architecture/modules/architecture/domain/entities/post.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';

abstract class PostState {}

class PostStateSuccess implements PostState {
  final List<Post> list;

  PostStateSuccess(this.list);
}

class PostStateStart implements PostState {}

class PostStateLoading implements PostState {}

class PostStateError implements PostState {
  final ApiException error;

  PostStateError(this.error);
}
