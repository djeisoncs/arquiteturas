
import 'package:architecture/modules/architecture/constantes/api_path.dart';
import 'package:dio/native_imp.dart';

import 'custom_interceptors.dart';

class CustomDio extends DioForNative {


  CustomDio() {
    interceptors.add(CustomInterceptors());
    options.baseUrl = ApiPath.API_BASE_URL;
    options.contentType = "application/json";
  }
}