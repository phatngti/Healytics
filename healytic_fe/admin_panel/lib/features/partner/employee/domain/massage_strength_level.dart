/// Enum representing massage strength/pressure levels.
///
/// Used in the massage therapist form for selecting
/// preferred strength.
enum MassageStrengthLevel {
  /// Soft pressure level.
  soft,

  /// Medium pressure level (default).
  medium,

  /// Strong pressure level.
  strong;

  /// Returns the user-friendly display name.
  String get displayName => switch (this) {
    MassageStrengthLevel.soft => 'Soft',
    MassageStrengthLevel.medium => 'Medium',
    MassageStrengthLevel.strong => 'Strong',
  };

  /// Returns the API value for backend communication.
  String get apiValue => switch (this) {
    MassageStrengthLevel.soft => 'SOFT',
    MassageStrengthLevel.medium => 'MEDIUM',
    MassageStrengthLevel.strong => 'STRONG',
  };
}
