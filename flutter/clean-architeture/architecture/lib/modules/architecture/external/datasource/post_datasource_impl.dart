

import 'package:architecture/modules/architecture/data/datasources/post_datasource.dart';
import 'package:architecture/modules/architecture/data/model/post_model.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:dio/dio.dart';

class PostDatasourceImpl implements PostDatasource {

  final Dio dio;


  PostDatasourceImpl(this.dio);

  @override
  Future<List<PostModel>> call(int id) async {
    final response = await dio.get("https://jsonplaceholder.typicode.com/posts/$id/comments");

    if (response.statusCode == 200) {
      return (response.data as List).map((m) => PostModel.fromMap(m)).toList();
    }

    throw ApiException();
  }

}