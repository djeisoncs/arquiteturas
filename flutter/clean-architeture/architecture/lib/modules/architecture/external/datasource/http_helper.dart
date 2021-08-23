

import 'package:architecture/modules/architecture/domain/erros/erros.dart';
import 'package:architecture/modules/architecture/external/custom_dio/custom_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class APIHelper {
  final CustomDio dio;

  APIHelper({@required this.dio}) {
    //
  }

  //for api helper testing only
  APIHelper.test({@required this.dio});

  void _initApiClient() {
    dio
      ..options
          .headers
          .addAll({'parameter':'parameter'})
      ..options.baseUrl = '';
  }

  Future<dynamic> get(String url) async {
    try {
      final response = await dio.get(url);
      final String res = json.encode(response.data);

      print('[API Helper - GET] Server Response: $res');

      return response.data;
    } on DioError catch (e) {
      print('[API Helper - GET] Connection Exception => ' + e.message);

      if (e != null && e.response != null && e.response.data != null)
        throw ApiException();
    }
  }

  Future<dynamic> post(String url,
      {Map headers, @required body, encoding}) async {
    try {
      print('[API Helper - POST] Server Request: $body');

      final response =
      await dio.post(url, data: body, options: Options(headers: headers));

      final String res = json.encode(response.data);
      print('[API Helper - POST] Server Response: ' + res);

      return response.data;
    } on DioError catch (e) {
      print('[API Helper - POST] Connection Exception => ' + e.message);

      if (e != null && e.response != null && e.response.data != null)
        throw ApiException();
    }
  }
}