

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

  // @override
  // Future<dynamic> create(PostModel entidade) async {
  //   return apiHelper.post("/posts", body: entidade.toJson());
  // }

  @override
  Future<PostModel> create(PostModel entidade) async {
    final response = await client.post("/posts", data: entidade.toJson());

    return PostModel.fromMap(response.data);
  }
}