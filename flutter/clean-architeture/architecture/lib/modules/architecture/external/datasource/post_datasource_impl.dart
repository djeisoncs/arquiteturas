
import 'package:architecture/modules/architecture/data/datasources/post_datasource.dart';
import 'package:architecture/modules/architecture/data/model/post_model.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';

class PostDatasourceImpl implements PostDatasource {

  final CustomDio client;

  PostDatasourceImpl(this.client);

  @override
  Future<List<PostModel>> call(String id) async {
    final response = await client.get("/posts/$id/comments");

    if (response.statusCode == 200) {
      return (response.data as List).map<PostModel>((m) => PostModel.fromMap(m)).toList();
    }

    throw ApiException();
  }

  Future<dynamic> call2(String id) async {
    final response = await client.get("/posts/$id/comments");

    if (response.statusCode == 200) {
      return response.data;
    }

    throw ApiException();
  }

  @override
  Future<PostModel> create(PostModel entidade) async {
    final response = await client.post("/posts", data: entidade.toJson());

    return PostModel.fromMap(response.data);
  }
}