/// Enum representing employee gender options.
///
/// Used in the contact info form for gender selection.
enum EmployeeGender {
  /// Female gender.
  female,

  /// Male gender.
  male,

  /// Non-binary gender identity.
  nonBinary,

  /// Prefer not to disclose gender.
  preferNotToSay;

  /// Returns the user-friendly display name.
  String get displayName => switch (this) {
    EmployeeGender.female => 'Female',
    EmployeeGender.male => 'Male',
    EmployeeGender.nonBinary => 'Non-binary',
    EmployeeGender.preferNotToSay => 'Prefer not to say',
  };
}
