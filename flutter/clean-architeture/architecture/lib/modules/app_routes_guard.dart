

import 'package:flutter_modular/flutter_modular.dart';

class AppRoutesGuard implements RouteGuard {
  @override
  Future<bool> canActivate(String path, ModularRoute router) {
    // TODO: implement canActivate
    throw UnimplementedError();
  }

  @override
  // TODO: implement guardedRoute
  String get guardedRoute => throw UnimplementedError();
  
}