
import 'entity.dart';

class Usuario implements Entity {

  @override
  String id;
  String login;
  String nome;
  String email;
  String token;
  String urlFoto;
  String senha;

  Usuario({this.id, this.login, this.nome, this.email, this.token, this.urlFoto,
      this.senha});
}