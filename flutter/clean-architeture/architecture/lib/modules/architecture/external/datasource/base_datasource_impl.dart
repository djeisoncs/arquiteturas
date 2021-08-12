
import 'package:architecture/modules/architecture/external/datasource/base_datasource.dart';
import 'package:dio/dio.dart';

class BaseDatasourceImpl implements BaseDatasource {

  final Dio dio;

  BaseDatasourceImpl(this.dio);
}