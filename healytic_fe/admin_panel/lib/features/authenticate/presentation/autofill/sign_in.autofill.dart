import 'package:admin_panel/core/entities/role.entity.dart';

/// UAT-only autofill defaults for the Sign-In form.
///
/// Activate via `?autofill=true` (e.g. `/?autofill=true`)
/// or the `autoFill` flag in `store.uat.json`.
///
/// Credentials match the seeded accounts in
/// `backend/src/database/seeds/users/user.seeder.ts`.
abstract final class SignInAutofill {
  // ── Admin ──
  static const adminEmail = 'admin@healytics.vn';
  static const adminPassword = 'admin@123';

  // ── Health Partner ──
  static const partnerEmail = 'partner@healytics.vn';
  static const partnerPassword = 'partner@123';

  static String getEmail(String role) {
    print('role: $role');
    if (role == Role.admin.value) {
      return adminEmail;
    }
    return partnerEmail;
  }

  static String getPassword(String role) {
    if (role == Role.admin.value) {
      return adminPassword;
    }
    return partnerPassword;
  }
}
