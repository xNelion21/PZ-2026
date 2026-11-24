import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pz_mobile/core/network/api_client_provider.dart';

void main() {
  test('shares a client configured with the overridden base URL', () {
    const baseUrl = 'http://10.0.2.2:8080';
    final container = ProviderContainer.test(
      overrides: [apiBaseUrlProvider.overrideWithValue(baseUrl)],
    );

    final client = container.read(apiClientProvider);

    expect(client.options.baseUrl, baseUrl);
    expect(container.read(apiClientProvider), same(client));
  });
}
