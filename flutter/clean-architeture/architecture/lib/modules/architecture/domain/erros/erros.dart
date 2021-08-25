
abstract class AppException implements Exception {}

class ApiException implements AppException {
  final String msg;

  ApiException({this.msg});
}

class AuthException implements AppException {}
