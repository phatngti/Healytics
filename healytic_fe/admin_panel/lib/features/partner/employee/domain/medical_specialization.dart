/// Enum representing medical specializations.
///
/// Used in the doctor form for specialization selection.
enum MedicalSpecialization {
  /// Cardiology specialization.
  cardiology,

  /// Dermatology specialization.
  dermatology,

  /// Orthopedics specialization.
  orthopedics,

  /// Pediatrics specialization.
  pediatrics,

  /// Neurology specialization.
  neurology;

  /// Returns the user-friendly display name.
  String get displayName => switch (this) {
    MedicalSpecialization.cardiology => 'Cardiology',
    MedicalSpecialization.dermatology => 'Dermatology',
    MedicalSpecialization.orthopedics => 'Orthopedics',
    MedicalSpecialization.pediatrics => 'Pediatrics',
    MedicalSpecialization.neurology => 'Neurology',
  };

  /// Returns the API value for backend communication.
  String get apiValue => switch (this) {
    MedicalSpecialization.cardiology => 'cardiology',
    MedicalSpecialization.dermatology => 'dermatology',
    MedicalSpecialization.orthopedics => 'orthopedics',
    MedicalSpecialization.pediatrics => 'pediatrics',
    MedicalSpecialization.neurology => 'neurology',
  };

  /// Returns a map of all specializations keyed by
  /// [apiValue] with [displayName] as the value.
  ///
  /// Useful for multi-select chip fields.
  static Map<String, String> get optionsMap => {
    for (final s in values) s.apiValue: s.displayName,
  };
}
