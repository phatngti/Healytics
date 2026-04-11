/// Keys used by the backend checklist to identify
/// each profile completion section.
enum ChecklistKey {
  coverImageUrl('coverImageUrl'),
  logoImageUrl('logoImageUrl'),
  description('description'),
  gallery('gallery'),
  certifications('certifications');

  const ChecklistKey(this.value);

  /// The raw key used in API responses.
  final String value;

  /// User-friendly label for display.
  String get label => switch (this) {
        ChecklistKey.coverImageUrl => 'Clinic cover image',
        ChecklistKey.logoImageUrl => 'Clinic logo image',
        ChecklistKey.description => 'Clinic description',
        ChecklistKey.gallery => 'Clinic gallery',
        ChecklistKey.certifications =>
          'Trust badges and certifications',
      };

  /// Whether the section is required
  /// for profile completion.
  bool get isRequired => switch (this) {
        ChecklistKey.coverImageUrl => true,
        ChecklistKey.logoImageUrl => true,
        ChecklistKey.description => true,
        ChecklistKey.gallery => true,
        ChecklistKey.certifications => false,
      };

  /// Parse from an API key string.
  static ChecklistKey? fromValue(String? value) {
    if (value == null) return null;
    return ChecklistKey.values.cast<ChecklistKey?>().firstWhere(
          (e) => e?.value == value,
          orElse: () => null,
        );
  }
}
