

import 'dart:convert';

import 'package:architecture/modules/architecture/data/datasources/post_datasource.dart';
import 'package:architecture/modules/architecture/data/model/post_model.dart';
import 'package:architecture/modules/architecture/domain/entities/post.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:architecture/modules/architecture/external/datasource/http_helper.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class PostDatasourceImpl implements PostDatasource {

  final CustomDio client;
  final APIHelper apiHelper; 


  PostDatasourceImpl(this.client, {this.apiHelper});

  @override
  Future<List<PostModel>> call(String id) async {
    final response = await client.get("/posts/$id/comments");

    if (response.statusCode == 200) {
      return (response.data as List).map((m) => PostModel.fromMap(m)).toList();
    }

    throw ApiException();
  }

  // @override
  // Future<dynamic> create(PostModel entidade) async {
  //   return apiHelper.post("/posts", body: entidade.toJson());
  // }

  @override
  Future<dynamic> create(PostModel entidade) async {
    try {

      final response =
      await client.post("/posts", data: entidade.toJson());

      final String res = json.encode(response.data);
      print('[API Helper - POST] Server Response: ' + res);

      return response.data;
    } on DioError catch (e) {
      print('[API Helper - POST] Connection Exception => ' + e.message);

      if (e != null && e.response != null && e.response.data != null)
        throw ApiException();
    }
  }

}