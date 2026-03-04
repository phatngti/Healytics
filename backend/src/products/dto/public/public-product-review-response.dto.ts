import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ProductReview } from '@/common/entities/product-review.entity';

export class PublicProductReviewResponseDto {
  @ApiProperty() reviewerName: string;
  @ApiPropertyOptional() avatarUrl: string | null;
  @ApiProperty({ example: 5 }) rating: number;
  @ApiProperty({ example: 'Completed' }) status: string;
  @ApiProperty({ example: '2025-05-11T00:00:00.000Z' }) date: string;
  @ApiProperty() text: string;
  @ApiProperty({ type: [String] }) imageUrls: string[];

  static fromEntity(review: ProductReview): PublicProductReviewResponseDto {
    const dto = new PublicProductReviewResponseDto();

    dto.reviewerName = review.reviewerName;
    dto.avatarUrl = review.avatarUrl ?? null;
    dto.rating = review.rating;
    dto.status = review.status;
    dto.date = review.date instanceof Date ? review.date.toISOString() : String(review.date);
    dto.text = review.text;
    dto.imageUrls = review.imageUrls ?? [];

    return dto;
  }

  static fromEntities(reviews: ProductReview[]): PublicProductReviewResponseDto[] {
    return reviews.map((r) => PublicProductReviewResponseDto.fromEntity(r));
  }
}
