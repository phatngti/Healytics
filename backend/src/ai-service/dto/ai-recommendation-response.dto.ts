import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Product } from '@/common/entities/product.entity';
import { Partner } from '@/common/entities/partner.entity';

// ─── Single Recommendation ──────────────────────────────────

/**
 * Flat health service recommendation DTO aligned with
 * PublicHealthServiceCardResponseDto for frontend consistency.
 */
export class AiRecommendationItemDto {
  @ApiProperty({ example: 'a1b2c3d4-...' })
  service_id: string;

  @ApiProperty({ example: 'Phục hồi cột sống chuyên sâu' })
  name: string;

  @ApiProperty({ example: 'phuc-hoi-cot-song-chuyen-sau' })
  slug: string;

  @ApiPropertyOptional({ example: 'https://images.unsplash.com/photo-...' })
  imageUrl: string | null;

  @ApiProperty({ example: 'Massage' })
  category: string;

  @ApiProperty({ example: '60 min' })
  duration: string;

  @ApiProperty({ example: '800,000' })
  price: string;

  @ApiProperty({ example: '4.8' })
  rating: string;

  @ApiProperty({ example: 'Healytics Spa' })
  vendorName: string;

  @ApiProperty({ example: 'Quận 1, Hồ Chí Minh' })
  location: string;

  @ApiProperty({
    type: [String],
    example: ['https://example.com/avatar1.jpg'],
  })
  staffAvatars: string[];

  @ApiProperty({ example: 'service' })
  type: string;

  /**
   * Maps a Product entity + Partner to the AI recommendation item shape.
   *
   * Mirrors the flat format of PublicHealthServiceCardResponseDto
   * so the AI chatbot and frontend share a consistent data contract.
   */
  static fromEntity(
    product: Product,
    fallbackPartner?: Partner | null,
    ratingAvg?: number,
  ): AiRecommendationItemDto {
    const dto = new AiRecommendationItemDto();
    const partner = product.partner ?? fallbackPartner ?? null;

    dto.service_id = product.id;
    dto.name = product.name;
    dto.slug = product.slug;

    // Thumbnail image
    dto.imageUrl =
      product.media?.find((m) => m.isThumbnail)?.url ??
      product.media?.[0]?.url ??
      null;

    // Category label
    dto.category = product.category?.name ?? 'Uncategorized';

    // Duration from product definition
    const minutes = product.productDefinition?.durationMinutes;
    dto.duration = minutes ? `${minutes} min` : '';

    // Price formatting (Vietnamese đồng)
    const price = product.salePrice ?? product.basePrice;
    dto.price = new Intl.NumberFormat('vi-VN').format(Number(price));

    // Average rating — pre-computed from TreatmentReview aggregate
    const avg = ratingAvg ?? 0;
    dto.rating = (Math.round(avg * 10) / 10).toString();

    // Vendor name: prefer product-level, fall back to partner brand
    dto.vendorName = product.vendorName ?? partner?.brandName ?? '';

    // Location from partner address hierarchy
    if (partner) {
      const parts = [
        partner.district?.fullName,
        partner.province?.fullName,
      ].filter(Boolean);
      dto.location = parts.join(', ');
    } else {
      dto.location = '';
    }

    // Staff avatars from eligible employees
    dto.staffAvatars = (product.productEmployeeEligibilities ?? [])
      .map((elig) => elig.employee?.avatarUrl)
      .filter((url): url is string => !!url);

    dto.type = product.type;

    return dto;
  }

  static fromEntities(
    products: Product[],
    fallbackPartner?: Partner | null,
    ratingsMap?: Map<string, { rating: number; count: number }>,
  ): AiRecommendationItemDto[] {
    return products.map((p) =>
      AiRecommendationItemDto.fromEntity(
        p,
        fallbackPartner,
        ratingsMap?.get(p.id)?.rating,
      ),
    );
  }
}

// ─── Top-level Response ─────────────────────────────────────

export class AiRecommendationsResponseDto {
  @ApiProperty({ example: 2 })
  total: number;

  @ApiProperty({ type: [AiRecommendationItemDto] })
  recommendations: AiRecommendationItemDto[];

  static create(
    products: Product[],
    fallbackPartner?: Partner | null,
    ratingsMap?: Map<string, { rating: number; count: number }>,
  ): AiRecommendationsResponseDto {
    const dto = new AiRecommendationsResponseDto();
    dto.recommendations = AiRecommendationItemDto.fromEntities(
      products,
      fallbackPartner,
      ratingsMap,
    );
    dto.total = dto.recommendations.length;
    return dto;
  }
}
