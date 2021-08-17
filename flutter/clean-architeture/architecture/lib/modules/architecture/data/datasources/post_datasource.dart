
import 'package:architecture/modules/architecture/data/model/PostModel.dart';

abstract class PostDatasource {


  Future<List<PostModel>> getPosts();
  Future<PostModel> creatPosts(PostModel postModel);
}