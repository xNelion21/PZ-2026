import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pz_mobile/core/network/api_client.dart';
import 'package:pz_mobile/core/network/api_exception.dart';

void main() {
  late _StubAdapter adapter;

  Dio client({Future<String?> Function()? readAccessToken}) {
    final dio = createApiClient(
      baseUrl: 'https://example.test/api',
      readAccessToken: readAccessToken,
    );
    adapter = _StubAdapter();
    dio.httpClientAdapter = adapter;
    addTearDown(() => dio.close(force: true));
    return dio;
  }

  test('rejects missing or invalid API configuration', () {
    for (final baseUrl in ['', '/api', 'ftp://example.test', 'https://']) {
      expect(() => createApiClient(baseUrl: baseUrl), throwsArgumentError);
    }
  });

  test(
    'uses the configured base URL and works without a token source',
    () async {
      final dio = client();
      await dio.get<void>('/trips');

      final request = adapter.lastRequest!;
      expect(request.uri, Uri.parse('https://example.test/api/trips'));
      expect(request.headers['Authorization'], isNull);
      expect(request.connectTimeout, const Duration(seconds: 10));
      expect(request.receiveTimeout, const Duration(seconds: 15));
      expect(request.followRedirects, isFalse);
    },
  );

  test('reads the current token for each API request', () async {
    String? token = 'test-token';
    final dio = client(readAccessToken: () async => token);

    await dio.get<void>('/trips');
    expect(adapter.lastRequest!.headers['Authorization'], 'Bearer test-token');

    token = null;
    await dio.get<void>('/trips');
    expect(adapter.lastRequest!.headers['Authorization'], isNull);
  });

  test('omits authorization for another origin', () async {
    final dio = client(readAccessToken: () async => 'test-token');

    await dio.get<void>('https://other.test/trips');
    expect(adapter.lastRequest!.headers['Authorization'], isNull);
  });

  test('normalizes token source errors before sending the request', () async {
    final dio = client(
      readAccessToken: () async => throw StateError('Token source unavailable'),
    );

    await expectLater(
      dio.get<void>('/trips'),
      throwsA(_apiError(ApiErrorKind.unexpected)),
    );
    expect(adapter.lastRequest, isNull);
  });

  test('classifies HTTP errors and preserves the status code', () async {
    final dio = client();

    adapter.statusCode = 401;
    await expectLater(
      dio.get<void>('/trips'),
      throwsA(
        _apiError(
          ApiErrorKind.unauthorized,
        ).having((error) => error.response?.statusCode, 'status code', 401),
      ),
    );

    adapter.statusCode = 500;
    await expectLater(
      dio.get<void>('/trips'),
      throwsA(_apiError(ApiErrorKind.http)),
    );
  });

  test('distinguishes network errors from timeouts', () async {
    final dio = client();

    adapter.errorType = DioExceptionType.connectionError;
    await expectLater(
      dio.get<void>('/trips'),
      throwsA(_apiError(ApiErrorKind.network)),
    );

    adapter.errorType = DioExceptionType.receiveTimeout;
    await expectLater(
      dio.get<void>('/trips'),
      throwsA(_apiError(ApiErrorKind.timeout)),
    );
  });
}

TypeMatcher<ApiException> _apiError(ApiErrorKind kind) =>
    isA<ApiException>().having((error) => error.kind, 'kind', kind);

class _StubAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;
  int statusCode = 200;
  DioExceptionType? errorType;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    final type = errorType;
    if (type != null) {
      throw DioException(requestOptions: options, type: type);
    }
    return ResponseBody.fromString('', statusCode);
  }

  @override
  void close({bool force = false}) {}
}
