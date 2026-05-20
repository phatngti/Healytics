import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import '../entities/store.entity.dart';
import '../models/store.model.dart';
import '../providers/auth_session.provider.dart';

/// HTTP client wrapper that intercepts 401 responses,
/// attempts a token refresh, and retries the request.
class AuthHttpClient extends http.BaseClient {
  AuthHttpClient({
    required this.authSessionStore,
    required this.backendBasePath,
    http.Client? inner,
  }) : _inner = inner ?? http.Client();

  final http.Client _inner;
  final AuthSessionStore authSessionStore;
  String backendBasePath;

  final _log = Logger('AuthHttpClient');
  Completer<bool>? _refreshCompleter;

  static const _authPaths = [
    '/auth/admin/login',
    '/auth/employee/login',
    '/auth/user/login',
    '/auth/partner/login',
    '/auth/refresh',
    '/auth/employee/refresh',
    '/auth/partner/refresh',
    '/auth/user/register',
    '/auth/partner/register',
  ];

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _inner.send(request);

    if (response.statusCode != 401 || _isAuthEndpoint(request.url)) {
      return response;
    }

    _log.info('401 received – attempting token refresh');

    final refreshed = await _tryRefreshToken();
    if (!refreshed) {
      _log.warning('Token refresh failed – forcing logout');
      authSessionStore.forceLogout();
      return response;
    }

    final retryRequest = _copyRequest(request);
    return _inner.send(retryRequest);
  }

  Future<bool> _tryRefreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();
    try {
      final refreshToken = Store.tryGet(StoreKey.refreshToken);
      if (refreshToken == null || refreshToken.isEmpty) {
        _refreshCompleter!.complete(false);
        return false;
      }

      final uri = Uri.parse('$backendBasePath/auth/employee/refresh');
      final res = await _inner.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final newAccess = body['access_token'] ?? body['accessToken'];
        final newRefresh = body['refresh_token'] ?? body['refreshToken'];

        if (newAccess is! String || newRefresh is! String) {
          _log.warning('Refresh response did not include tokens');
          _refreshCompleter!.complete(false);
          return false;
        }

        await Store.put(StoreKey.accessToken, newAccess);
        await Store.put(StoreKey.refreshToken, newRefresh);

        _log.info('Token refreshed successfully');
        _refreshCompleter!.complete(true);
        return true;
      }

      _log.warning(
        'Refresh endpoint returned '
        '${res.statusCode}',
      );
      _refreshCompleter!.complete(false);
      return false;
    } catch (e, s) {
      _log.severe('Token refresh error', e, s);
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  bool _isAuthEndpoint(Uri url) {
    return _authPaths.any((p) => url.path.endsWith(p));
  }

  http.BaseRequest _copyRequest(http.BaseRequest original) {
    final accessToken = Store.get(StoreKey.accessToken, '');

    if (original is http.Request) {
      final copy = http.Request(original.method, original.url)
        ..headers.addAll(original.headers)
        ..body = original.body;

      if (accessToken.isNotEmpty) {
        copy.headers['Authorization'] = 'Bearer $accessToken';
      }
      return copy;
    }

    throw UnsupportedError(
      'Cannot retry a '
      '${original.runtimeType} request',
    );
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
