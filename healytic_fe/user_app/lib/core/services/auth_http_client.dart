import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';

/// HTTP client wrapper that intercepts 401 responses,
/// attempts a token refresh, and retries the request.
///
/// If the refresh fails the session is cleared so the
/// router guard redirects to the login screen.
class AuthHttpClient extends http.BaseClient {
  AuthHttpClient({
    required this.authSessionStore,
    required this.backendBasePath,
    http.Client? inner,
  }) : _inner = inner ?? http.Client();

  final http.Client _inner;
  final AuthSessionStore authSessionStore;

  /// Full base path for the backend service,
  /// e.g. `https://api.healytics.vn/backend`.
  String backendBasePath;

  final _log = Logger('AuthHttpClient');

  // ── Refresh lock ──────────────────────────────────
  Completer<bool>? _refreshCompleter;

  /// Paths that should **not** trigger a 401 retry
  /// to avoid infinite loops.
  static const _authPaths = [
    '/auth/login',
    '/auth/refresh',
    '/auth/register',
    '/auth/partner/login',
    '/auth/partner/refresh',
  ];

  @override
  Future<http.StreamedResponse> send(
    http.BaseRequest request,
  ) async {
    final response = await _inner.send(request);

    if (response.statusCode != 401 ||
        _isAuthEndpoint(request.url)) {
      return response;
    }

    _log.info('401 received – attempting token refresh');

    final refreshed = await _tryRefreshToken();
    if (!refreshed) {
      _log.warning(
        'Token refresh failed – forcing logout',
      );
      authSessionStore.forceLogout();
      return response;
    }

    // Retry with the fresh access token.
    final retryRequest = _copyRequest(request);
    return _inner.send(retryRequest);
  }

  /// Returns `true` if the token was refreshed.
  Future<bool> _tryRefreshToken() async {
    // If another request is already refreshing, wait
    // for the result instead of firing a second call.
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();
    try {
      final refreshToken = Store.tryGet(
        StoreKey.refreshToken,
      );
      if (refreshToken == null || refreshToken.isEmpty) {
        _refreshCompleter!.complete(false);
        return false;
      }

      final uri = Uri.parse(
        '$backendBasePath/auth/refresh',
      );
      final res = await _inner.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final body =
            jsonDecode(res.body) as Map<String, dynamic>;
        final newAccess = body['accessToken'] as String;
        final newRefresh = body['refreshToken'] as String;

        await Store.put(StoreKey.accessToken, newAccess);
        await Store.put(
          StoreKey.refreshToken,
          newRefresh,
        );

        _log.info('Token refreshed successfully');
        _refreshCompleter!.complete(true);
        return true;
      }

      _log.warning(
        'Refresh endpoint returned ${res.statusCode}',
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

  /// Creates a copy of [original] with the updated
  /// Authorization header from the Store.
  http.BaseRequest _copyRequest(http.BaseRequest original) {
    final accessToken = Store.get(
      StoreKey.accessToken,
      '',
    );

    if (original is http.Request) {
      final copy = http.Request(original.method, original.url)
        ..headers.addAll(original.headers)
        ..body = original.body;

      if (accessToken.isNotEmpty) {
        copy.headers['Authorization'] =
            'Bearer $accessToken';
      }
      return copy;
    }

    // Fallback for streamed / multipart – unlikely for
    // standard API calls but safe to handle.
    throw UnsupportedError(
      'Cannot retry a ${original.runtimeType} request',
    );
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
