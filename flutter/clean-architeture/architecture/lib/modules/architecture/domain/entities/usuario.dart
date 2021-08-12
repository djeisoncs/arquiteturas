
import 'package:architecture/modules/architecture/domain/entities/entity.dart';

// ignore: must_be_immutable
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