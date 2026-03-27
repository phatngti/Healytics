/// Dev-only autofill defaults for the Category Add form.
///
/// Activate via `?autofill=true`
/// (e.g. `/admin/categories/add?autofill=true`).
///
/// Only active when [kDebugMode] is `true`.
abstract final class CategoryAddAutofill {
  static const name = 'Skincare & Facial Treatments';
  static const description =
      'Professional skincare services including facials, chemical peels, '
      'and advanced skin rejuvenation treatments.';
  static const status = 'Active';
  static const sortOrder = '1';
  static const iconName = 'spa';
  static const colorHex = '#1A7B99';
}
