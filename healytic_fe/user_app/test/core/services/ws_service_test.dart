import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/core/services/ws.service.dart';

void main() {
  group('normalizeSocketIoGatewayUrl', () {
    test('adds the default HTTPS port when it is omitted', () {
      expect(
        normalizeSocketIoGatewayUrl('https://dev.healytics.me'),
        'https://dev.healytics.me:443',
      );
    });

    test('keeps explicit ports and trims trailing slashes', () {
      expect(
        normalizeSocketIoGatewayUrl('http://localhost:8000/'),
        'http://localhost:8000',
      );
    });

    test('preserves gateway base paths', () {
      expect(
        normalizeSocketIoGatewayUrl('https://example.com/gateway/'),
        'https://example.com:443/gateway',
      );
    });
  });
}
