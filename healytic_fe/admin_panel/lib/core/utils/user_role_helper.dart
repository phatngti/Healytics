import 'package:admin_panel/core/entities/role.entity.dart';
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
    return getRole() == Role.admin.value;
  }

  /// Returns true if the current user has provider role.
  static bool isProvider() {
    return getRole() == Role.health_partner.value;
  }

  /// Returns true if the user is logged in.
  ///
  /// In mock mode, checks whether `mockRole` has been persisted
  /// (set only after a successful sign-in via [SignInProvider]).
  /// In production mode, checks for a non-empty access token.
  static bool isLoggedIn() {
    final isMockMode = Store.tryGet(StoreKey.mockFlag) ?? false;
    if (isMockMode) {
      final mockRole = Store.tryGet(StoreKey.mockRole) ?? '';
      return mockRole.isNotEmpty;
    }
    final accessToken =
        Store.tryGet(StoreKey.accessToken) ?? '';
    return accessToken.isNotEmpty;
  }

  /// Returns true if the provider is verified.
  ///
  /// In mock mode, uses `partnerVerified` from store.json.
  /// In production mode, uses the stored verification status.
  static bool isProviderVerified() {
    final isMockMode = Store.tryGet(StoreKey.mockFlag) ?? false;
    if (isMockMode) {
      return Store.tryGet(StoreKey.partnerVerified) ?? false;
    }
    return Store.tryGet(StoreKey.partnerVerified) ?? false;
  }

  // Set the partner verified status
  static Future<void> setPartnerVerified(bool verified) {
    return Store.put(StoreKey.partnerVerified, verified);
  }

  /// Returns true when the verified partner finished clinic profile completion.
  ///
  /// In mock mode, defaults to `true` so existing mocked dashboard flows continue
  /// to work unless explicitly overridden.
  static bool isProviderProfileCompleted() {
    final isMockMode = Store.tryGet(StoreKey.mockFlag) ?? false;
    if (isMockMode) {
      return Store.tryGet(StoreKey.partnerProfileCompleted) ?? true;
    }
    return Store.tryGet(StoreKey.partnerProfileCompleted) ?? false;
  }

  static Future<void> setPartnerProfileCompleted(
    bool completed,
  ) {
    return Store.put(
      StoreKey.partnerProfileCompleted,
      completed,
    );
  }

  static Future<void> syncPartnerFlagsFromAccessToken(
    String accessToken,
  ) async {
    try {
      final decoded = JwtDecoder.decode(accessToken);
      final verificationStatus = decoded['verificationStatus']
          ?.toString()
          .toUpperCase();
      final isVerified = verificationStatus == 'APPROVED';
      final isProfileCompleted =
          decoded['partnerProfileCompleted'] == true ||
          decoded['partnerProfileCompleted']
                  ?.toString()
                  .toLowerCase() ==
              'true';

      await setPartnerVerified(isVerified);
      await setPartnerProfileCompleted(isProfileCompleted);
    } catch (_) {
      await setPartnerVerified(false);
      await setPartnerProfileCompleted(false);
    }
  }

  /// Clears all session-specific flags so that
  /// [isLoggedIn] returns `false` on next cold start.
  ///
  /// Includes `mockRole` (mock mode login marker) and
  /// partner verification/completion flags.
  static Future<void> clearSession() async {
    await Store.delete(StoreKey.mockRole);
    await Store.delete(StoreKey.partnerVerified);
    await Store.delete(StoreKey.partnerProfileCompleted);
  }

  /// Alias kept for backward compatibility.
  @Deprecated('Use clearSession() instead')
  static Future<void> clearPartnerFlags() => clearSession();
}
