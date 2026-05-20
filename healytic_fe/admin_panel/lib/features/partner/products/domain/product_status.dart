/// Product visibility/publication status.
enum ProductStatus {
  draft,
  active,
  inactive;

  /// User-friendly display name.
  String get displayName => switch (this) {
    ProductStatus.draft => 'Draft',
    ProductStatus.active => 'Active',
    ProductStatus.inactive => 'Inactive',
  };

  /// API value for backend communication.
  String get apiValue => switch (this) {
    ProductStatus.draft => 'draft',
    ProductStatus.active => 'active',
    ProductStatus.inactive => 'inactive',
  };

  /// Parse from API value.
  static ProductStatus? fromApiValue(String? value) {
    if (value == null) return null;
    return switch (value.toLowerCase()) {
      'draft' => ProductStatus.draft,
      'active' => ProductStatus.active,
      'inactive' => ProductStatus.inactive,
      _ => null,
    };
  }
}
