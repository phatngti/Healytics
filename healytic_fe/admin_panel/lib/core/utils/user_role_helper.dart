import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Helper class for determining user role and admin status.
///
/// Supports two modes:
/// 1. Mock mode: When `mockFlag` is `true`, uses `mockRole` from store.json
/// 2. Production mode: Decodes the JWT access token to get the role
class UserRoleHelper {
  UserRoleHelper._();

  /// Returns the current user's role.
  ///
  /// Priority:
  /// 1. If `mockFlag` is enabled, returns `mockRole` from config
  /// 2. Otherwise, decodes JWT token to get role
  /// 3. Returns empty string if no role can be determined
  static String getRole() {
    final isMockMode = Store.tryGet(StoreKey.mockFlag) ?? false;

    if (isMockMode) {
      return Store.tryGet(StoreKey.mockRole) ?? '';
    }

    final accessToken = Store.tryGet(StoreKey.accessToken) ?? '';
    if (accessToken.isNotEmpty) {
      try {
        final decoded = JwtDecoder.decode(accessToken);
        return decoded['role'] ?? '';
      } catch (_) {
        return '';
      }
    }

    return '';
  }

  /// Returns true if the current user has admin role.
  static bool isAdmin() {
    return getRole() == 'admin';
  }

  /// Returns true if the current user has provider role.
  static bool isProvider() {
    return getRole() == 'provider';
  }

  /// Returns true if the user is logged in (has access token or in mock mode).
  static bool isLoggedIn() {
    final isMockMode = Store.tryGet(StoreKey.mockFlag) ?? false;
    if (isMockMode) {
      return true;
    }
    final accessToken = Store.tryGet(StoreKey.accessToken) ?? '';
    return accessToken.isNotEmpty;
  }

  /// Returns true if the provider is verified.
  ///
  /// In mock mode, uses `partnerVerified` from store.json.
  /// In production mode, uses the stored verification status.
  static bool isProviderVerified() {
    return Store.tryGet(StoreKey.partnerVerified) ?? false;
  }
}
