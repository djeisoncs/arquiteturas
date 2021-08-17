
import 'package:architecture/modules/architecture/data/datasources/post_datasource.dart';
import 'package:architecture/modules/architecture/data/model/PostModel.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:dio/dio.dart';

class PostDatasourceImpl implements PostDatasource {

  final CustomDio _client;


  PostDatasourceImpl(this._client);

  @override
  Future<PostModel> creatPosts(PostModel postModel) {
    // TODO: implement creatPosts
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>> getPosts() async {
    try{
      final response = await _client.get("/posts");
      return (response.data as List).map((e) => PostModel.fromJson(e)).toList();
    } on DioError catch(e) {
      throw(e.message);
    }
  }

}