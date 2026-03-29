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

  /// Returns the API value for backend communication.
  ///
  /// Note: [preferNotToSay] returns `null` as API has no
  /// equivalent. [nonBinary] maps to `'OTHER'`.
  String? get apiValue => switch (this) {
    EmployeeGender.female => 'FEMALE',
    EmployeeGender.male => 'MALE',
    EmployeeGender.nonBinary => 'OTHER',
    EmployeeGender.preferNotToSay => null,
  };

  /// Returns the [EmployeeGender] for the given API [value].
  ///
  /// Returns `null` if no matching gender is found.
  static EmployeeGender? fromApiValue(String? value) {
    if (value == null) return null;
    return switch (value.toUpperCase()) {
      'MALE' => EmployeeGender.male,
      'FEMALE' => EmployeeGender.female,
      'OTHER' => EmployeeGender.nonBinary,
      _ => null,
    };
  }
}
