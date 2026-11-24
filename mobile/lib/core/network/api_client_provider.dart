import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

final apiBaseUrlProvider = Provider<String>((ref) => configuredApiBaseUrl);

final apiClientProvider = Provider<Dio>((ref) {
  final client = createApiClient(
    baseUrl: ref.watch(apiBaseUrlProvider),
    readAccessToken: () async => null,
  );
  ref.onDispose(client.close);
  return client;
});
