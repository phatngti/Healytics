import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.entity.freezed.dart';
part 'review.entity.g.dart';

/// Domain entity for a product review
///
/// Used for displaying and creating reviews
/// associated with a product.
@Freezed(toJson: true)
abstract class ReviewEntity with _$ReviewEntity {
  const factory ReviewEntity({
    required String reviewerName,
    String? avatarUrl,
    required int rating,
    String? status,
    required String date,
    required String text,
    @Default([]) List<String> imageUrls,
  }) = _ReviewEntity;

  factory ReviewEntity.fromJson(Map<String, dynamic> json) =>
      _$ReviewEntityFromJson(json);
}
