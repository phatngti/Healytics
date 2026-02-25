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
    MedicalEducation.doctorOfMedicine => 'Doctor of Medicine',
    MedicalEducation.masterOfMedicine => 'Master of Medicine',
    MedicalEducation.bachelorOfMedicine => 'Bachelor of Medicine',
    MedicalEducation.associateDegree => 'Associate Degree',
    MedicalEducation.other => 'Other',
  };
}
