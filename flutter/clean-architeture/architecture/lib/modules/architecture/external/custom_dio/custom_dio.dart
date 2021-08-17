

import 'package:architecture/modules/architecture/external/custom_dio/custom_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';

class CustomDio extends DioForNative {


  CustomDio() {
    options.baseUrl = "https://jsonplaceholder.typicode.com";
    interceptors.add(CustomInterceptors());
    options.connectTimeout = 5000;
    options.contentType = "application/json;charset=UTF-8";
  }
}