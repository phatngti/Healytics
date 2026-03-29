import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Product } from '@/common/entities/product.entity';

export class PublicHealthServiceRecommendedResponseDto {
  @ApiProperty() id: string;
  @ApiProperty() title: string;
  @ApiPropertyOptional() imageUrl: string | null;
  @ApiProperty({ example: 4.9 }) rating: number;
  @ApiProperty({ example: '(500+ Reviews)' }) reviewLabel: string;
  @ApiProperty({ example: '1.2k+ Booked' }) bookedLabel: string;
  @ApiProperty({ example: '350.000₫' }) price: string;

  static fromEntity(
    product: Product,
    ratingData?: { rating: number; count: number },
  ): PublicHealthServiceRecommendedResponseDto {
    const dto = new PublicHealthServiceRecommendedResponseDto();

    dto.id = product.id;
    dto.title = product.name;
    dto.imageUrl =
      product.media?.find((m) => m.isThumbnail)?.url ??
      product.media?.[0]?.url ??
      null;

    // Rating — pre-computed from TreatmentReview aggregate
    dto.rating = ratingData?.rating ?? 0;

    // Review label
    const count = ratingData?.count ?? 0;
    if (count >= 500) {
      dto.reviewLabel = '(500+ Reviews)';
    } else if (count > 0) {
      dto.reviewLabel = `(${count} Reviews)`;
    } else {
      dto.reviewLabel = '(0 Reviews)';
    }

    // Booked label (placeholder)
    dto.bookedLabel = '100+ Booked';

    // Price formatting
    const price = product.salePrice ?? product.basePrice;
    dto.price = new Intl.NumberFormat('vi-VN').format(Number(price)) + '₫';

    return dto;
  }

  static fromEntities(
    products: Product[],
    ratingsMap?: Map<string, { rating: number; count: number }>,
  ): PublicHealthServiceRecommendedResponseDto[] {
    return products.map((p) =>
      PublicHealthServiceRecommendedResponseDto.fromEntity(p, ratingsMap?.get(p.id)),
    );
  }
}
