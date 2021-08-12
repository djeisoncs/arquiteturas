
import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:architecture/modules/architecture/domain/repositories/usuario_repository.dart';
import 'package:architecture/modules/architecture/domain/usercases/impl/usercase_impl.dart';
import 'package:architecture/modules/architecture/domain/usercases/usuario_usercase.dart';

class UsuarioUsercaseImpl extends UsercaseIpml<Usuario> implements UsuarioUsercase {

  final UsuarioRepository repository;

  UsuarioUsercaseImpl(this.repository) : super(repository);

}