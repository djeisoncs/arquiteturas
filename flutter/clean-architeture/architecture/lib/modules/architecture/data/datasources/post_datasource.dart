

import 'package:architecture/modules/architecture/data/model/post_model.dart';
import 'package:architecture/modules/architecture/domain/entities/post.dart';

abstract class PostDatasource {

  Future<List<PostModel>> call(String id);

  Future<PostModel> create(PostModel entidade);
}