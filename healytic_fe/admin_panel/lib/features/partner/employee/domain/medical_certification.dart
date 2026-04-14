/// Enum representing common medical certifications.
///
/// Used in the doctor form for certification selection.
enum MedicalCertification {
  /// Basic Life Support certification.
  bls,

  /// Advanced Cardiovascular Life Support.
  acls,

  /// Pediatric Advanced Life Support.
  pals,

  /// Board Certified specialist.
  boardCertified,

  /// First Aid certification.
  firstAid,

  /// Other certification.
  other;

  /// Returns the user-friendly display name.
  String get displayName => switch (this) {
    MedicalCertification.bls => 'Basic Life Support (BLS)',
    MedicalCertification.acls => 'Advanced Cardiovascular Life Support (ACLS)',
    MedicalCertification.pals => 'Pediatric Advanced Life Support (PALS)',
    MedicalCertification.boardCertified => 'Board Certified',
    MedicalCertification.firstAid => 'First Aid',
    MedicalCertification.other => 'Other',
  };

  /// Returns the API value for backend communication.
  String get apiValue => switch (this) {
    MedicalCertification.bls => 'BLS',
    MedicalCertification.acls => 'ACLS',
    MedicalCertification.pals => 'PALS',
    MedicalCertification.boardCertified => 'Board Certified',
    MedicalCertification.firstAid => 'First Aid',
    MedicalCertification.other => 'Other',
  };

  /// Returns a map of all certifications keyed by
  /// [apiValue] with [displayName] as the value.
  ///
  /// Useful for multi-select chip fields.
  static Map<String, String> get optionsMap => {
    for (final c in values) c.apiValue: c.displayName,
  };
}
