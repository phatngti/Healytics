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
}
