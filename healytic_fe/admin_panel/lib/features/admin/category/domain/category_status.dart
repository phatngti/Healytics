/// Category visibility status.
enum CategoryStatus {
  active,
  inactive;

  /// User-friendly display name.
  String get displayName => switch (this) {
    CategoryStatus.active => 'Active',
    CategoryStatus.inactive => 'Inactive',
  };

  /// API value for backend communication.
  String get apiValue => switch (this) {
    CategoryStatus.active => 'active',
    CategoryStatus.inactive => 'inactive',
  };

  /// Parse from API value.
  static CategoryStatus? fromApiValue(
    String? value,
  ) {
    if (value == null) return null;
    return switch (value.toLowerCase()) {
      'active' => CategoryStatus.active,
      'inactive' => CategoryStatus.inactive,
      _ => null,
    };
  }
}
