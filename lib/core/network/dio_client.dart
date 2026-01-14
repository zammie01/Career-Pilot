import 'package:dio/dio.dart';

import 'interceptors/auth_interceptors.dart';
import 'interceptors/logging_interceptors.dart';


class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com/',
      // connectTimeout: 5000,
      // receiveTimeout: 5000,
    ));

    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
    ]);
  }
}
