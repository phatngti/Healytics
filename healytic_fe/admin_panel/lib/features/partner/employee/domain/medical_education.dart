/// Enum representing medical education levels.
///
/// Used in the doctor form for education selection.
enum MedicalEducation {
  /// Doctor of Medicine (MD) degree.
  doctorOfMedicine,

  /// Master of Medicine degree.
  masterOfMedicine,

  /// Bachelor of Medicine degree.
  bachelorOfMedicine,

  /// Associate Degree in medical field.
  associateDegree,

  /// Other education qualification.
  other;

  /// Returns the user-friendly display name.
  String get displayName => switch (this) {
    MedicalEducation.doctorOfMedicine =>
      'Doctor of Medicine',
    MedicalEducation.masterOfMedicine =>
      'Master of Medicine',
    MedicalEducation.bachelorOfMedicine =>
      'Bachelor of Medicine',
    MedicalEducation.associateDegree =>
      'Associate Degree',
    MedicalEducation.other => 'Other',
  };

  /// Returns the API value for backend communication.
  String get apiValue => switch (this) {
    MedicalEducation.doctorOfMedicine =>
      'Doctor of Medicine',
    MedicalEducation.masterOfMedicine =>
      'Master of Medicine',
    MedicalEducation.bachelorOfMedicine =>
      'Bachelor of Medicine',
    MedicalEducation.associateDegree =>
      'Associate Degree',
    MedicalEducation.other => 'Other',
  };

  /// Returns a map of all education levels keyed by
  /// [apiValue] with [displayName] as the value.
  ///
  /// Useful for multi-select chip fields.
  static Map<String, String> get optionsMap => {
    for (final e in values) e.apiValue: e.displayName,
  };
}
