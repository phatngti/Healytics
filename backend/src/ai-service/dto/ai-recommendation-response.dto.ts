import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Product } from '@/common/entities/product.entity';
import { Partner } from '@/common/entities/partner.entity';

// ─── Nested DTOs ─────────────────────────────────────────────

export class AiPriceDto {
  @ApiProperty({ example: 800000 })
  amount: number;

  @ApiProperty({ example: 'VND' })
  currency: string;
}

export class AiRatingDto {
  @ApiProperty({ example: 4.8 })
  average: number;

  @ApiProperty({ example: 124 })
  total_reviews: number;
}

export class AiLocationDto {
  @ApiProperty({ example: '123 Nguyễn Huệ' })
  address: string;

  @ApiProperty({ example: 'Quận 1' })
  district: string;

  @ApiProperty({ example: 'Hồ Chí Minh' })
  city: string;
}

// ─── Single Recommendation ──────────────────────────────────

export class AiRecommendationItemDto {
  @ApiProperty({ example: 'SV002' })
  service_id: string;

  @ApiProperty({ example: 'Phục hồi cột sống chuyên sâu' })
  name: string;

  @ApiPropertyOptional({ example: 'https://images.unsplash.com/photo-...' })
  image_url: string | null;

  @ApiPropertyOptional({ example: 'Premium' })
  badge: string | null;

  @ApiProperty({ example: 1200 })
  booked_count: number;

  @ApiProperty({ type: AiPriceDto })
  price: AiPriceDto;

  @ApiPropertyOptional({ example: 'BS Nguyễn Văn A' })
  staff_name: string | null;

  @ApiProperty({ type: AiRatingDto })
  rating: AiRatingDto;

  @ApiProperty({ type: AiLocationDto })
  location: AiLocationDto;

  @ApiProperty({ type: [String], example: ['2026-02-21T09:00:00'] })
  slots: string[];

  /**
   * Maps a Product entity + Partner to the AI recommendation item shape.
   *
   * Fields not yet stored in DB (`booked_count`, `slots`, `badge`)
   * are set to sensible defaults.
   */
  static fromEntity(
    product: Product,
    partner?: Partner | null,
  ): AiRecommendationItemDto {
    const dto = new AiRecommendationItemDto();

    dto.service_id = product.id;
    dto.name = product.name;

    // Thumbnail image
    dto.image_url =
      product.media?.find((m) => m.isThumbnail)?.url ??
      product.media?.[0]?.url ??
      null;

    // Badge — not yet in DB, default null
    dto.badge = null;

    // Booked count — not yet in DB, default 0
    dto.booked_count = 0;

    // Price
    dto.price = {
      amount: Number(product.salePrice ?? product.basePrice),
      currency: product.currency || 'VND',
    };

    // Staff name — first eligible employee
    const firstEmployee =
      product.productEmployeeEligibilities?.[0]?.employee ?? null;
    dto.staff_name = firstEmployee?.fullName ?? null;

    // Rating — product_reviews table dropped; defaults to 0 until aggregated separately
    dto.rating = {
      average: 0,
      total_reviews: 0,
    };

    // Location from partner
    if (partner) {
      dto.location = {
        address: partner.streetAddress ?? '',
        district: partner.district?.fullName ?? '',
        city: partner.province?.fullName ?? '',
      };
    } else {
      dto.location = { address: '', district: '', city: '' };
    }

    // Slots — not yet in DB, default empty array
    dto.slots = [];

    return dto;
  }

  static fromEntities(
    products: Product[],
    partner?: Partner | null,
  ): AiRecommendationItemDto[] {
    return products.map((p) =>
      AiRecommendationItemDto.fromEntity(p, partner),
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
    partner?: Partner | null,
  ): AiRecommendationsResponseDto {
    const dto = new AiRecommendationsResponseDto();
    dto.recommendations = AiRecommendationItemDto.fromEntities(
      products,
      partner,
    );
    dto.total = dto.recommendations.length;
    return dto;
  }
}
