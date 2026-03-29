// Domain entity for a single medical credential.
//
// Pure Dart — no Flutter or framework imports.

/// Represents a medical credential with a descriptive
/// title and an optional license identifier.
class MedicalCredentialEntity {
  /// Human-readable credential name
  /// (e.g. "Board Certified Dermatologist").
  final String title;

  /// Optional license ID (e.g. "LIC-2020-SPA-001").
  final String? license;

  const MedicalCredentialEntity({
    required this.title,
    this.license,
  });

  /// Whether this credential has a license ID.
  bool get hasLicense =>
      license != null && license!.isNotEmpty;

  /// Whether the license follows
  /// the "LIC-…" pattern.
  bool get isLicense =>
      hasLicense &&
      license!.toUpperCase().startsWith('LIC-');
}
