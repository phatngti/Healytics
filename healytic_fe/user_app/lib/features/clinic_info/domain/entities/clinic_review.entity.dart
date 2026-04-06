// Pure-Dart entities for the Reviews tab.
// Platform-agnostic — no Flutter or Riverpod imports.

/// Overall rating summary for a clinic.
class ClinicReviewSummary {
  const ClinicReviewSummary({
    required this.averageRating,
    required this.totalReviewCount,
    required this.ratingLabel,
    required this.starDistribution,
  });

  /// Average rating out of 5, e.g. `4.9`.
  final double averageRating;

  /// Total number of reviews, e.g. `2500`.
  final int totalReviewCount;

  /// Human-readable quality label, e.g. "Excellent".
  final String ratingLabel;

  /// Percentage distribution per star level.
  ///
  /// Keys are 1–5 (star count), values are
  /// fractions 0.0–1.0.
  /// E.g. `{5: 0.92, 4: 0.06, 3: 0.01, ...}`.
  final Map<int, double> starDistribution;
}

/// A filter pill for the review feed.
class ClinicReviewFilter {
  const ClinicReviewFilter({
    required this.id,
    required this.label,
    this.starCount,
    this.requiresMedia = false,
  });

  /// Unique identifier, e.g. `'all'`, `'5-star'`.
  final String id;

  /// Display label, e.g. "All (2.5k)".
  final String label;

  /// If non-null, filter reviews to this star count.
  final int? starCount;

  /// If true, only show reviews with media.
  final bool requiresMedia;
}

/// A single user review.
class ClinicReviewEntity {
  const ClinicReviewEntity({
    required this.id,
    required this.reviewerName,
    required this.reviewerInitial,
    required this.starCount,
    this.memberBadge,
    required this.dateLabel,
    this.serviceName,
    this.serviceIcon,
    required this.reviewText,
    this.mediaUrls = const [],
    this.clinicResponse,
  });

  final String id;

  /// Masked reviewer name, e.g. `"n***a"`.
  final String reviewerName;

  /// First letter for the avatar fallback.
  final String reviewerInitial;

  /// Star rating, 1–5.
  final int starCount;

  /// Optional membership badge text.
  ///
  /// E.g. `"GOLD MEMBER"`, `"MEMBER"`, or null.
  final String? memberBadge;

  /// Formatted date string, e.g. `"04-04-2026"`.
  final String dateLabel;

  /// Name of the service reviewed.
  final String? serviceName;

  /// Material icon name for the service chip.
  final String? serviceIcon;

  /// The review body text.
  final String reviewText;

  /// URLs of images attached to the review.
  final List<String> mediaUrls;

  /// The clinic's reply, if any.
  final ClinicReviewResponse? clinicResponse;

  /// Whether this review has attached media.
  bool get hasMedia => mediaUrls.isNotEmpty;
}

/// The clinic's reply to a review.
class ClinicReviewResponse {
  const ClinicReviewResponse({required this.responseText});

  final String responseText;
}

/// Paginated bundle returned by the datasource.
class ClinicReviewsData {
  const ClinicReviewsData({
    required this.summary,
    required this.filters,
    required this.reviews,
    required this.totalCount,
    required this.hasMore,
  });

  final ClinicReviewSummary summary;
  final List<ClinicReviewFilter> filters;
  final List<ClinicReviewEntity> reviews;

  /// Total number of reviews matching current filter.
  final int totalCount;

  /// Whether more pages are available.
  final bool hasMore;
}
