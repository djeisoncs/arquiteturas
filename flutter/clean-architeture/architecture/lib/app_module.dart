
import 'package:architecture/modules/architecture/data/repositories/post_repository.dart';
import 'package:architecture/modules/architecture/domain/usercases/impl/post_usercase_impl.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:architecture/modules/architecture/external/datasource/post_datasource_impl.dart';
import 'package:architecture/modules/architecture/presenter/post/post_bloc.dart';
import 'package:architecture/modules/architecture/presenter/post/post_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {

  @override
  List<Bind<Object>> get binds => [
    Bind.singleton((i) => CustomDio()),
    Bind.singleton((i) => PostDatasourceImpl(i())),
    Bind.singleton((i) => PostRepositoryImpl(i())),
    Bind.singleton((i) => PostUsercaseImpl(i())),
    Bind.singleton((i) => PostBloc(i())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (_, __) => PostPage()),
  ];
}