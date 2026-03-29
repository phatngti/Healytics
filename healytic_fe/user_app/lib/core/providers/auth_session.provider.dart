import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';

class AuthSessionStore {
  bool get isMockMode => AppEnvironment.current.useMock;

  /// Returns true if the user is logged in (has a valid,
  /// non-expired access token or is in mock mode).
  bool get isLoggedIn => isMockMode || _isTokenValid();

  Stream<String?> watchAccessToken() => Store.watch(StoreKey.accessToken);

  String? get currentUserDisplayName {
    if (!_isTokenValid()) {
      _clearSession();
      return null;
    }

    final accessToken = Store.tryGet(StoreKey.accessToken)!;
    try {
      final claims = JwtDecoder.decode(accessToken);
      final candidate =
          claims['name'] ??
          claims['given_name'] ??
          claims['preferred_username'] ??
          claims['email'];

      if (candidate is String && candidate.trim().isNotEmpty) {
        return candidate;
      }
    } catch (_) {
      // Fallback when token payload is not decodable.
    }

    _clearSession();
    return null;
  }

  /// Returns the current user's UUID from the JWT
  /// `sub` claim, or `null` if unavailable.
  String? get currentUserId {
    final token = Store.tryGet(StoreKey.accessToken);
    if (token == null || token.isEmpty) return null;
    try {
      final claims = JwtDecoder.decode(token);
      return claims['sub'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Validates the stored access token exists and has
  /// not expired.
  bool _isTokenValid() {
    final token = Store.tryGet(StoreKey.accessToken);
    if (token == null || token.isEmpty) return false;

    try {
      return !JwtDecoder.isExpired(token);
    } catch (_) {
      return false;
    }
  }

  void _clearSession() {
    Store.delete(StoreKey.accessToken);
    Store.delete(StoreKey.refreshToken);
  }

  /// Clears all tokens and forces the user back to
  /// the login screen via the router guard.
  void forceLogout() => _clearSession();
}

final authSessionStoreProvider = Provider<AuthSessionStore>((ref) {
  return AuthSessionStore();
});

final currentUserDisplayNameProvider = Provider<String?>((ref) {
  return ref.watch(authSessionStoreProvider).currentUserDisplayName;
});

/// Provides the current user's UUID extracted from
/// the JWT `sub` claim.
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authSessionStoreProvider).currentUserId;
});
