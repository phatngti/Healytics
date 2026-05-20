import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';

/**
 * Public-facing review response DTO.
 * Maps from a real TreatmentReview entity (product_treatment_reviews table).
 * The reviewer's name is derived from Account → UserProfile.
 */
export class PublicHealthServiceReviewResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @ApiProperty({ example: 'Nguyen Van A' })
  reviewerName: string;

  @ApiPropertyOptional({ example: 'https://example.com/avatar.jpg' })
  avatarUrl: string | null;

  @ApiProperty({ example: 5 })
  rating: number;

  @ApiPropertyOptional({ example: 'Great session, very relaxing atmosphere.' })
  comment: string | null;

  @ApiProperty({ type: [String], example: ['On-time', 'Relaxing', 'Clean'] })
  tags: string[];

  @ApiProperty({
    type: [String],
    example: ['https://cdn.healytics.com/reviews/photo1.jpg'],
  })
  photoUrls: string[];

  @ApiProperty({ example: '2026-03-29T13:00:00.000Z' })
  createdAt: string;

  /**
   * Maps a TreatmentReview entity → public DTO.
   * Expects `review.user` and `review.user.userProfile` to be loaded.
   */
  static fromEntity(
    review: TreatmentReview,
  ): PublicHealthServiceReviewResponseDto {
    const dto = new PublicHealthServiceReviewResponseDto();

    dto.id = review.id;

    // Resolve reviewer name from Account → UserProfile
    const profile = review.user?.userProfile;
    const firstName = profile?.firstName ?? '';
    const lastName = profile?.lastName ?? '';
    const fullName = [firstName, lastName].filter(Boolean).join(' ').trim();
    dto.reviewerName = fullName || 'Anonymous';

    // UserProfile does not store avatar; default to null
    dto.avatarUrl = null;

    dto.rating = review.rating;
    dto.comment = review.comment ?? null;
    dto.tags = review.tags ?? [];
    dto.photoUrls = review.photoUrls ?? [];
    dto.createdAt =
      review.createdAt instanceof Date
        ? review.createdAt.toISOString()
        : String(review.createdAt);

    return dto;
  }

  static fromEntities(
    reviews: TreatmentReview[],
  ): PublicHealthServiceReviewResponseDto[] {
    return reviews.map((r) =>
      PublicHealthServiceReviewResponseDto.fromEntity(r),
    );
  }
}
