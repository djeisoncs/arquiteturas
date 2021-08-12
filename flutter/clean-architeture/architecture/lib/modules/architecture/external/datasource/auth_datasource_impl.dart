

import 'package:architecture/modules/architecture/data/datasources/auth_datasource.dart';
import 'package:architecture/modules/architecture/data/model/usuario_model.dart';
import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthDatasourceImpl implements AuthDatasource {

  Dio dio;

  AuthDatasourceImpl(this.dio);

  @override
  Future<UsuarioModel> auth(String username, String password) async {
    UsuarioModel usuarioModel = UsuarioModel(login: username, senha: password);
    final response = await dio.post("path", options: Options(contentType: "application/json"), queryParameters: {"username":username, "password":password});

    if (isNotNull(response) && response.statusCode == 200) {
      return usuarioModel;
    }
    throw ApiException();
  }
}