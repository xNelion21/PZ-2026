import 'package:dio/dio.dart';

import 'api_exception.dart';

const configuredApiBaseUrl = String.fromEnvironment('API_BASE_URL');

/// Creates the client to share across API consumers.
Dio createApiClient({
  String baseUrl = configuredApiBaseUrl,
  Future<String?> Function()? readAccessToken,
}) {
  final baseUri = Uri.tryParse(baseUrl.trim());
  if (baseUri == null ||
      (baseUri.scheme != 'http' && baseUri.scheme != 'https') ||
      baseUri.host.isEmpty ||
      baseUri.userInfo.isNotEmpty ||
      baseUri.hasQuery ||
      baseUri.hasFragment) {
    throw ArgumentError('API_BASE_URL must be an absolute HTTP or HTTPS URL.');
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUri.toString(),
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      followRedirects: false,
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (readAccessToken != null && options.uri.origin == baseUri.origin) {
          final token = (await readAccessToken())?.trim();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
      onError: (error, handler) =>
          handler.next(error is ApiException ? error : ApiException(error)),
    ),
  );
  return dio;
}
