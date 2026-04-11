import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_review.entity.freezed.dart';

/// A customer review displayed on the dashboard.
///
/// Decoupled from [ReviewEntity] in products domain
/// to follow Clean Architecture feature boundaries.
@freezed
abstract class DashboardReview with _$DashboardReview {
  const factory DashboardReview({
    required String reviewerName,
    String? avatarUrl,
    required int rating,

    /// e.g., 'published', 'hidden'
    required String status,
    required DateTime date,
    required String text,
    @Default([]) List<String> imageUrls,
  }) = _DashboardReview;
}
