

import 'package:architecture/modules/architecture/data/model/post_model.dart';

abstract class PostDatasource {

  Future<List<PostModel>> call(int id);
}