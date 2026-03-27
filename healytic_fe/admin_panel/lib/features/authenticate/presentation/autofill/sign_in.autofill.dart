/// Dev-only autofill defaults for the Sign-In form.
///
/// Activate via `?autofill=true` (e.g. `/?autofill=true`)
/// or the `autoFill` flag in `store.json`.
///
/// Only active when [kDebugMode] is `true`.
abstract final class SignInAutofill {
  static const email = 'partner@healytics.vn';
  static const password = 'Partner@123';
}
