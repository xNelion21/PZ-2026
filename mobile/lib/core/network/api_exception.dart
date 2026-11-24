import 'package:dio/dio.dart';

enum ApiErrorKind {
  unauthorized,
  http,
  network,
  timeout,
  cancelled,
  unexpected,
}

class ApiException extends DioException {
  ApiException(DioException cause)
    : kind = switch (cause.type) {
        DioExceptionType.badResponse when cause.response?.statusCode == 401 =>
          ApiErrorKind.unauthorized,
        DioExceptionType.badResponse => ApiErrorKind.http,
        DioExceptionType.connectionError ||
        DioExceptionType.badCertificate => ApiErrorKind.network,
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.transformTimeout => ApiErrorKind.timeout,
        DioExceptionType.cancel => ApiErrorKind.cancelled,
        DioExceptionType.unknown => ApiErrorKind.unexpected,
      },
      super(
        requestOptions: cause.requestOptions,
        response: cause.response,
        type: cause.type,
        error: cause.error,
        stackTrace: cause.stackTrace,
        message: cause.message,
      );

  final ApiErrorKind kind;
}
