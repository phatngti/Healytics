/// Domain entity representing a single AI-recommended
/// health service for the home page.
class AiRecommendation {
  /// Backend health-service identifier.
  final String serviceId;

  /// Human-readable service name.
  final String name;

  /// Optional hero-image URL.
  final String imageUrl;

  /// Optional badge label (e.g. "Popular", "New").
  final String? badge;

  /// Total number of bookings.
  final int bookedCount;

  /// Formatted display price (e.g. "850,000 VND").
  final String price;

  /// Numeric price amount for sorting / comparison.
  final double priceAmount;

  /// ISO currency code (e.g. "VND").
  final String currency;

  /// Average star rating (0.0–5.0).
  final double rating;

  /// Number of reviews.
  final int totalReviews;

  /// Short location label (e.g. "District 1, HCMC").
  final String location;

  /// Optional staff/specialist display name.
  final String? staffName;

  /// Available time slots (ISO strings).
  final List<String> slots;

  const AiRecommendation({
    required this.serviceId,
    required this.name,
    this.imageUrl = '',
    this.badge,
    this.bookedCount = 0,
    this.price = '',
    this.priceAmount = 0,
    this.currency = 'VND',
    this.rating = 0,
    this.totalReviews = 0,
    this.location = '',
    this.staffName,
    this.slots = const [],
  });
}
