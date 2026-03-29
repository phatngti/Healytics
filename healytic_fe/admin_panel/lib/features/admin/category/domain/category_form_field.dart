/// Enum representing all form field keys used across
/// category add/edit forms.
///
/// Centralises string literals to prevent typos and
/// enable IDE auto-complete.
enum CategoryFormField {
  categoryName('category_name'),
  description('description'),
  status('status'),
  sortOrder('sort_order'),
  iconName('icon_name'),
  colorHex('color_hex');

  const CategoryFormField(this.key);

  /// The string key used in `FormBuilder` values map.
  final String key;
}
