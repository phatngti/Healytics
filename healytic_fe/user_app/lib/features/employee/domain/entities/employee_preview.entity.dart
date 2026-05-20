/// Lightweight preview data for an employee, used to
/// render partial UI instantly while the full
/// [EmployeeDetailEntity] loads in the background.
///
/// Pure Dart — no Flutter or framework imports.
class EmployeePreview {
  /// Unique employee identifier.
  final String id;

  /// Display name.
  final String name;

  /// Optional avatar image URL.
  final String? avatarUrl;

  /// Primary specialty or job title.
  final String? specialty;

  /// Human-readable role label
  /// (e.g. "Doctor", "Therapist").
  final String? roleLabel;

  /// Average rating (0–5).
  final double? rating;

  /// Total number of reviews.
  final int? reviewCount;

  const EmployeePreview({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.specialty,
    this.roleLabel,
    this.rating,
    this.reviewCount,
  });
}
