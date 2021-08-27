
import 'dart:convert';

import 'package:architecture/modules/architecture/data/datasources/auth_datasource.dart';
import 'package:architecture/modules/architecture/data/model/usuario_model.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthDatasourceImpl implements AuthDatasource {

  final CustomDio client;

  AuthDatasourceImpl(this.client);

  @override
  Future<UsuarioModel> auth(String username, String password) async {
    final response = await client.post("/auth", queryParameters: {"username":username, "password":password});

    Map<String, dynamic> token = Jwt.parseJwt(response.data);

    return UsuarioModel.fromMap(jsonDecode(token['TOKEN.USER']));
  }

}