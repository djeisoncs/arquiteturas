
import 'package:architecture/modules/architecture/data/repositories/post_repository.dart';
import 'package:architecture/modules/architecture/domain/usercases/impl/post_usercase_impl.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:architecture/modules/architecture/external/datasource/post_datasource_impl.dart';
import 'package:architecture/modules/architecture/presenter/auth/bloc/auth_bloc.dart';
import 'package:architecture/modules/architecture/presenter/auth/views/auth_screen.dart';
import 'package:architecture/modules/architecture/presenter/post/post_bloc.dart';
import 'package:architecture/modules/architecture/presenter/post/post_page.dart';
import 'package:architecture/modules/architecture/constantes/app_routes.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/architecture/data/repositories/auth_repository_impl.dart';
import 'modules/architecture/domain/usercases/impl/auth_usercase_impl.dart';
import 'modules/architecture/external/datasource/auth_datasource_impl.dart';

class AppModule extends Module {

  @override
  List<Bind<Object>> get binds => [
    Bind.singleton((i) => CustomDio()),
    /// Binds referente Post
    Bind.singleton((i) => PostDatasourceImpl(i())),
    Bind.singleton((i) => PostRepositoryImpl(i())),
    Bind.singleton((i) => PostUsercaseImpl(i())),
    Bind.singleton((i) => PostBloc(i())),
    /// Binds referente a autenticação
    Bind.singleton((i) => AuthDatasourceImpl(i())),
    Bind.singleton((i) => AuthRepositoryImpl(i())),
    Bind.singleton((i) => AuthUsercaseImpl(i())),
    Bind.singleton((i) => AuthBloc(i())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(AppRoutes.AUTH, child: (_, __) => AuthScreen()),
    ChildRoute(AppRoutes.HOME, child: (_, __) => PostPage()),
  ];
}