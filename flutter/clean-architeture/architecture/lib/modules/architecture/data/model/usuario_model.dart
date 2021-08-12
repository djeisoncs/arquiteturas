

import 'dart:convert' as convert;

import 'package:architecture/modules/architecture/data/model/model.dart';
import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:architecture/modules/architecture/utils/util.dart';

// ignore: must_be_immutable
class UsuarioModel extends Usuario with Model {

  String id;
  String login;
  String nome;
  String email;
  String token;
  String urlFoto;
  String senha;

  UsuarioModel({this.id, this.login, this.nome, this.email, this.token,
      this.urlFoto, this.senha});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'login': this.login,
      'nome': this.nome,
      'email': this.email,
      'token': this.token,
      'urlFoto': this.urlFoto,
      'senha': this.senha,
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    if (isNull(map)) return null;

    return UsuarioModel(
      id: map['id'] as String,
      login: map['login'] as String,
      nome: map['nome'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
      urlFoto: map['urlFoto'] as String,
      senha: map['senha'] as String,
    );
  }

  @override
  List<Object> get props => [login, nome, email];

  static Usuario fromJson(String value) => UsuarioModel.fromMap(convert.json.decode(value));

}