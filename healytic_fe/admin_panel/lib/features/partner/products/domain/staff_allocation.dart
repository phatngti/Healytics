/// Staff allocation strategy for a product/service.
enum StaffAllocation {
  any,
  specific;

  /// User-friendly display name.
  String get displayName => switch (this) {
    StaffAllocation.any => 'Any',
    StaffAllocation.specific => 'Specific',
  };

  /// API value for backend communication.
  String get apiValue => switch (this) {
    StaffAllocation.any => 'any',
    StaffAllocation.specific => 'specific',
  };

  /// Parse from API value.
  static StaffAllocation? fromApiValue(
    String? value,
  ) {
    if (value == null) return null;
    return switch (value.toLowerCase()) {
      'any' => StaffAllocation.any,
      'specific' => StaffAllocation.specific,
      _ => null,
    };
  }
}
