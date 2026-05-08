import 'package:admin_panel/core/entities/role.entity.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';

/// Dev-only mock account definitions.
///
/// Each account maps to a specific verification/profile
/// state so developers can test all partner flows quickly.
abstract final class DevMockAccounts {
  // ── Admin ──
  static const adminEmail = 'admin@healytics.dev';
  static const adminPassword = 'dev123';

  // ── Partner: Pending Verification ──
  static const pendingEmail = 'pending@healytics.dev';
  static const pendingPassword = 'dev123';

  // ── Partner: Incomplete Profile ──
  static const incompleteEmail =
      'incomplete@healytics.dev';
  static const incompletePassword = 'dev123';

  // ── Partner: Fully Completed ──
  static const completedEmail = 'partner@healytics.dev';
  static const completedPassword = 'dev123';

  /// All available quick-select partner accounts.
  static const partnerAccounts = [
    DevPartnerAccount(
      label: '🕐 Pending Verification',
      description: 'Not verified by admin yet',
      email: pendingEmail,
      password: pendingPassword,
      verificationStatus: 'PENDING',
      isProfileCompleted: false,
    ),
    DevPartnerAccount(
      label: '📝 Incomplete Profile',
      description: 'Verified but profile not done',
      email: incompleteEmail,
      password: incompletePassword,
      verificationStatus: 'APPROVED',
      isProfileCompleted: false,
    ),
    DevPartnerAccount(
      label: '✅ Fully Completed',
      description: 'Verified and profile completed',
      email: completedEmail,
      password: completedPassword,
      verificationStatus: 'APPROVED',
      isProfileCompleted: true,
    ),
  ];

  /// Resolves a partner account by email.
  ///
  /// Falls back to the fully-completed account for
  /// unrecognized emails.
  static DevPartnerAccount resolveByEmail(
    String email,
  ) {
    return partnerAccounts.firstWhere(
      (a) => a.email == email,
      orElse: () => partnerAccounts.last,
    );
  }

  /// Builds a [SignInResponseEntity] for admin role.
  static SignInResponseEntity buildAdminResponse() {
    return const SignInResponseEntity(
      accessToken: 'mock_admin_access_token',
      refreshToken: 'mock_admin_refresh_token',
      role: 'admin',
    );
  }

  /// Builds a [SignInResponseEntity] for a partner
  /// account resolved by [email].
  static SignInResponseEntity buildPartnerResponse(
    String email,
  ) {
    final account = resolveByEmail(email);
    return SignInResponseEntity(
      accessToken: 'mock_partner_${account.email}',
      refreshToken: 'mock_partner_refresh_token',
      role: Role.health_partner.value,
      verificationStatus: account.verificationStatus,
      verificationCompletedAt: account.isProfileCompleted
          ? DateTime.now().toIso8601String()
          : null,
    );
  }
}

/// Describes a single dev mock partner account.
class DevPartnerAccount {
  const DevPartnerAccount({
    required this.label,
    required this.description,
    required this.email,
    required this.password,
    required this.verificationStatus,
    required this.isProfileCompleted,
  });

  /// Display label for the quick-select chip.
  final String label;

  /// Short description of the account state.
  final String description;

  /// Email credential.
  final String email;

  /// Password credential.
  final String password;

  /// Verification status: `PENDING` or `APPROVED`.
  final String verificationStatus;

  /// Whether the partner profile is complete.
  final bool isProfileCompleted;
}
