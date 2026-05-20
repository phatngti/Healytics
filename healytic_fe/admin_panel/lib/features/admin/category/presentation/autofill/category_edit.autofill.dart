/// Dev-only autofill defaults for the Category Edit form.
///
/// Activate via `?autofill=true`
/// (e.g. `/admin/category/edit/cat_123?autofill=true`).
///
/// Only active when [kDebugMode] is `true`.
/// Uses different values from [CategoryAddAutofill] to
/// distinguish edit from add during testing.
abstract final class CategoryEditAutofill {
  static const name = 'Updated Skincare & Wellness';
  static const description =
      'Updated professional skincare and wellness services '
      'including advanced facial treatments and body therapies.';
  static const status = 'Active';
  static const sortOrder = '2';
  static const iconName = 'spa';
  static const colorHex = '#2E8B57';
}
