/// Dev-only autofill defaults for the Partner Registration
/// form ([SignUpFormScreen]).
///
/// Activate via `?autofill=true`
/// (e.g. `/sign-up?autofill=true`)
/// or the `autoFill` flag in `store.*.json`.
///
/// Only active when [kDebugMode] is `true`.
abstract final class SignUpFormAutofill {
  // ── Section 1: Account Information ──

  static const username = 'test_partner';
  static const email = 'partner-test@healytics.vn';
  static const password = 'partner@123';
  static const confirmPassword = 'partner@123';

  // ── Section 2: Business & Partner Information ──

  static const brandName = 'Serenity Spa';
  static const legalName = 'Serenity Wellness LLC';
  static const taxCode = '0123456789';
  static const businessTypes = <String>['SPA_BEAUTY'];

  // ── Section 2: Business Location ──

  static const streetAddress = '123 Nguyen Hue, Ben Nghe Ward';

  // ── Section 3: Legal Representative ──

  static const representativeName = 'Nguyen Van A';
  static const representativePosition = 'Director';
  static const representativePhone = '0912345678';
  static const idType = 'Citizen Identity Card';
  static const idNumber = '012345678901';
  static final idIssueDate = DateTime(2022, 1, 15);
}
