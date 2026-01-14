/// Enum representing the type of therapist employee.
///
/// Used to differentiate between spa therapists and massage therapists,
/// which have different skill sets and attributes.
enum TherapistType {
  /// Spa therapist specializing in facial treatments, body wraps, etc.
  spa,

  /// Massage therapist specializing in various massage techniques.
  massage;

  /// Returns the user-friendly display name for the therapist type.
  String get displayName => switch (this) {
    TherapistType.spa => 'Spa Therapist',
    TherapistType.massage => 'Massage Therapist',
  };

  /// Returns the API value used for backend communication.
  String get apiValue => switch (this) {
    TherapistType.spa => 'SPA',
    TherapistType.massage => 'MASSAGE',
  };
}
