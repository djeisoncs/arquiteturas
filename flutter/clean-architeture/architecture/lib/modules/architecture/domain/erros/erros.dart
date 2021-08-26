
abstract class AppException implements Exception {}

class AppError implements AppException {
  final String msg;

  AppError({this.msg});
}

class ApiException implements AppException {
  final String msg;

  ApiException({this.msg});
}

class AuthException implements AppException {}
