

import 'package:architecture/modules/architecture/data/datasources/auth_datasource.dart';
import 'package:architecture/modules/architecture/data/model/PostModel.dart';
import 'package:architecture/modules/architecture/data/model/usuario_model.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:architecture/modules/architecture/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthDatasourceImpl implements AuthDatasource {

  final CustomDio _client;

  AuthDatasourceImpl(this._client);

  @override
  Future<UsuarioModel> auth(String username, String password) async {
    UsuarioModel usuarioModel = UsuarioModel(login: username, senha: password);
    final response = await _client.post("path", options: Options(contentType: "application/json"), queryParameters: {"username":username, "password":password});

    if (isNotNull(response) && response.statusCode == 200) {
      return usuarioModel;
    }
    throw ApiException();
  }


  Future<List<PostModel>> getPosts() async {
    Response response;
   try {
     response  = await _client.post("/posts");
     return (response.data as List).map((e) => PostModel.fromJson(e)).toList();
   } on DioError catch(e) {
     throw(e.message);
   }
  }

}