import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}

NetworkException handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return NetworkException('Connection Timeout');
    case DioExceptionType.sendTimeout:
      return NetworkException('Send Timeout');
    case DioExceptionType.receiveTimeout:
      return NetworkException('Receive Timeout');
    case DioExceptionType.cancel:
      return NetworkException('Request Cancelled');
    case DioExceptionType.badResponse:
      return NetworkException(
          'Received invalid status code: ${error.response?.statusCode}');
    case DioExceptionType.unknown:
    default:
      return NetworkException('Unknown Network Error');
  }
}

