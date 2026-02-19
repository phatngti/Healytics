import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';

class AuthSessionStore {
  bool get isMockMode => Store.tryGet(StoreKey.mockFlag) == 'true';

  /// Returns true if the user is logged in (has access token or
  /// in mock mode).
  bool get isLoggedIn =>
      isMockMode || Store.tryGet(StoreKey.accessToken)?.isNotEmpty == true;

  Stream<String?> watchAccessToken() => Store.watch(StoreKey.accessToken);

  String get currentUserDisplayName {
    final accessToken = Store.tryGet(StoreKey.accessToken);
    if (accessToken == null || accessToken.isEmpty) {
      return 'Sarah';
    }

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
      // Keep fallback when token payload is not decodable.
    }

    return 'Sarah';
  }
}

final authSessionStoreProvider = Provider<AuthSessionStore>((ref) {
  return AuthSessionStore();
});

final currentUserDisplayNameProvider = Provider<String>((ref) {
  return ref.watch(authSessionStoreProvider).currentUserDisplayName;
});
