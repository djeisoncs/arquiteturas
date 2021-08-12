
import 'package:architecture/modules/architecture/data/model/usuario_model.dart';

abstract class AuthDatasource {

  Future<UsuarioModel> auth(String username, String password);

}