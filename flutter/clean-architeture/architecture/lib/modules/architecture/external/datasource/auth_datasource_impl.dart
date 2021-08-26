
import 'package:architecture/modules/architecture/data/datasources/auth_datasource.dart';
import 'package:architecture/modules/architecture/data/model/usuario_model.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';

class AuthDatasourceImpl implements AuthDatasource {

  final CustomDio client;

  AuthDatasourceImpl(this.client);

  @override
  Future<UsuarioModel> auth(String username, String password) {
    // TODO: implement auth
    throw UnimplementedError();
  }

}