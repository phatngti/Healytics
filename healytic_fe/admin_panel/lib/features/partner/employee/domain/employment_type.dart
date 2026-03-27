/// Enum representing employee employment types.
///
/// Used in the professional role form for employment
/// classification.
enum EmploymentType {
  /// Full-time employment.
  fullTime,

  /// Part-time employment.
  partTime,

  /// Contractor / freelance employment.
  contractor,

  /// Seasonal employment.
  seasonal;

  /// Returns the user-friendly display name.
  String get displayName => switch (this) {
    EmploymentType.fullTime => 'Full-Time',
    EmploymentType.partTime => 'Part-Time',
    EmploymentType.contractor => 'Contractor',
    EmploymentType.seasonal => 'Seasonal',
  };

  /// Returns the API value for backend communication.
  String get apiValue => switch (this) {
    EmploymentType.fullTime => 'FULL_TIME',
    EmploymentType.partTime => 'PART_TIME',
    EmploymentType.contractor => 'CONTRACTOR',
    EmploymentType.seasonal => 'SEASONAL',
  };
}
