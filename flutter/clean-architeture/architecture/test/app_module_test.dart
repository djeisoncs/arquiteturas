
import 'package:architecture/app_module.dart';
import 'package:architecture/init_modular.dart';
import 'package:architecture/modules/architecture/domain/usercases/auth_usercase.dart';
import 'package:architecture/modules/architecture/domain/usercases/impl/post_usercase_impl.dart';
import 'package:architecture/modules/architecture/domain/usercases/post_usercase.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DioMock extends Mock implements CustomDio {}
main() {

  final dio = DioMock();

  initModule(AppModule(), replaceBinds: [
    Bind<CustomDio>((i) => dio),
  ]);

  test("Deve recuperar o PostUsercase sem erro", () {
    final usercase = Modular.get<PostUsercase>();

    expect(usercase, isA<PostUsercaseImpl>());
  });

  test("Deve recuperar o AuthUsercase sem erro", () {
    final usercase = Modular.get<AuthUsercase>();

    expect(usercase, isA<AuthUsercase>());
  });
}