/// Enum representing therapist experience levels.
///
/// Used for both spa and massage therapist forms.
enum TherapistLevel {
  /// Junior therapist with less experience.
  junior,

  /// Senior therapist with significant experience.
  senior,

  /// Master therapist with expert-level experience.
  master;

  /// Returns the user-friendly display name.
  String get displayName => switch (this) {
    TherapistLevel.junior => 'Junior',
    TherapistLevel.senior => 'Senior',
    TherapistLevel.master => 'Master',
  };

  /// Returns the API value for backend communication.
  String get apiValue => switch (this) {
    TherapistLevel.junior => 'JUNIOR',
    TherapistLevel.senior => 'SENIOR',
    TherapistLevel.master => 'MASTER',
  };

  /// Returns the [TherapistLevel] for the given API [value].
  ///
  /// Returns `null` if no matching level is found.
  static TherapistLevel? fromApiValue(String? value) {
    if (value == null) return null;
    return switch (value.toUpperCase()) {
      'JUNIOR' => TherapistLevel.junior,
      'SENIOR' => TherapistLevel.senior,
      'MASTER' => TherapistLevel.master,
      _ => null,
    };
  }
}
