import 'package:dio/dio.dart';

class CityException implements Exception {
  final String message;

  CityException(this.message);

  static String mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';

      case DioExceptionType.badResponse:
        return 'Server error. Please try again later.';

      case DioExceptionType.cancel:
        return 'Request was cancelled';

      case DioExceptionType.connectionError:
        return 'Network error occurred. Please check your connection.';

      case DioExceptionType.badCertificate:
        return 'Network error occurred. Please check your connection.';

      case DioExceptionType.unknown:
        return 'Network error occurred. Please check your connection.';
    }
  }
}
