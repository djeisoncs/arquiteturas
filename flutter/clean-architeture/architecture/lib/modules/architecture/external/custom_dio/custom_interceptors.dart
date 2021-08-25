

import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:dio/dio.dart';

class CustomInterceptors extends InterceptorsWrapper {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
  }

  void _tratarErro(DioError erro) {
    if (erro.response?.statusCode == 401) {
      throw ApiException(msg: "Teste");
    }
  }
}