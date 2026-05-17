import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { SpecialistReview } from '@/common/entities/specialist-review.entity';

/**
 * Public-facing employee review response.
 *
 * Maps from specialist_reviews and exposes only fields needed by user-facing
 * employee profiles.
 */
export class PublicEmployeeReviewResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @ApiProperty({ example: 'Nguyen Van A' })
  reviewerName: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    example: 'https://example.com/avatar.jpg',
  })
  avatarUrl: string | null;

  @ApiProperty({ example: 5 })
  rating: number;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    example: 'Very attentive and professional throughout.',
  })
  comment: string | null;

  @ApiProperty({ type: [String], example: ['Professional', 'Attentive'] })
  tags: string[];

  @ApiProperty({ example: true })
  wouldRecommend: boolean;

  @ApiProperty({ example: '2026-03-29T13:01:00.000Z' })
  createdAt: string;

  static fromEntity(review: SpecialistReview): PublicEmployeeReviewResponseDto {
    const dto = new PublicEmployeeReviewResponseDto();
    dto.id = review.id;

    const profile = review.user?.userProfile;
    const firstName = profile?.firstName ?? '';
    const lastName = profile?.lastName ?? '';
    const fullName = [firstName, lastName].filter(Boolean).join(' ').trim();
    dto.reviewerName = fullName || 'Anonymous';
    dto.avatarUrl = null;

    dto.rating = review.rating;
    dto.comment = review.comment ?? null;
    dto.tags = review.tags ?? [];
    dto.wouldRecommend = review.wouldRecommend;
    dto.createdAt =
      review.createdAt instanceof Date
        ? review.createdAt.toISOString()
        : String(review.createdAt);

    return dto;
  }

  static fromEntities(
    reviews: SpecialistReview[],
  ): PublicEmployeeReviewResponseDto[] {
    return reviews.map((review) =>
      PublicEmployeeReviewResponseDto.fromEntity(review),
    );
  }
}
