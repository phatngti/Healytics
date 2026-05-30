import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Product } from '@/common/entities/product.entity';
import { Partner } from '@/common/entities/partner.entity';

/**
 * Flat health service card DTO used by listing endpoints
 * (premium-treatments, home-recommend).
 */
export class PublicHealthServiceCardResponseDto {
  @ApiProperty({ example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ example: 'Deep Tissue Massage' })
  name: string;

  @ApiProperty({ example: 'deep-tissue-massage' })
  slug: string;

  @ApiPropertyOptional({ example: 'https://example.com/image.jpg' })
  imageUrl: string | null;

  @ApiProperty({ example: 'Massage' })
  category: string;

  @ApiPropertyOptional({ example: 'e2a7d9b7-...' })
  categoryId: string | null;

  @ApiPropertyOptional({ example: 'f7c8b2d1-...' })
  parentCategoryId: string | null;

  @ApiPropertyOptional({ example: 'Spa & Beauty' })
  parentCategoryName: string | null;

  @ApiProperty({ example: '60 min' })
  duration: string;

  @ApiProperty({ example: '₫500,000' })
  price: string;

  @ApiProperty({ example: 500000 })
  priceAmount: number;

  @ApiProperty({ example: '4.9' })
  rating: string;

  @ApiProperty({ example: 'Healytics Spa' })
  vendorName: string;

  @ApiPropertyOptional({ example: 'b2519c94-...' })
  clinicId: string | null;

  @ApiProperty({ example: 'District 1, HCMC' })
  location: string;

  @ApiProperty({ type: [String], example: ['https://example.com/avatar1.jpg'] })
  staffAvatars: string[];

  @ApiProperty({ example: 'service' })
  type: string;

  static fromEntity(
    product: Product,
    partner?: Partner | null,
    ratingAvg?: number,
  ): PublicHealthServiceCardResponseDto {
    const dto = new PublicHealthServiceCardResponseDto();
    const resolvedPartner = product.partner ?? partner ?? null;

    dto.id = product.id;
    dto.name = product.name;
    dto.slug = product.slug;

    // Thumbnail image
    dto.imageUrl =
      product.media?.find((m) => m.isThumbnail)?.url ??
      product.media?.[0]?.url ??
      null;

    // Category label
    dto.category = product.category?.name ?? 'Uncategorized';
    dto.categoryId = product.categoryId ?? product.category?.id ?? null;
    dto.parentCategoryId = product.category?.parent?.id ?? null;
    dto.parentCategoryName = product.category?.parent?.name ?? null;

    // Duration from product definition
    const minutes = product.productDefinition?.durationMinutes;
    dto.duration = minutes ? `${minutes} min` : '';

    // Price formatting (Vietnamese đồng)
    const price = product.salePrice ?? product.basePrice;
    dto.priceAmount = Number(price) || 0;
    dto.price = '₫' + new Intl.NumberFormat('vi-VN').format(Number(price));

    // Average rating — pre-computed from TreatmentReview aggregate
    const avg = ratingAvg ?? 0;
    dto.rating = (Math.round(avg * 10) / 10).toString();

    // Vendor name: prefer product-level, fall back to partner brand
    dto.vendorName = product.vendorName ?? resolvedPartner?.brandName ?? '';
    dto.clinicId = resolvedPartner?.id ?? product.partnerId ?? null;

    // Location from partner address hierarchy
    if (resolvedPartner) {
      const parts = [
        resolvedPartner.district?.fullName,
        resolvedPartner.province?.fullName,
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
    partner?: Partner | null,
    ratingsMap?: Map<string, { rating: number; count: number }>,
  ): PublicHealthServiceCardResponseDto[] {
    return products.map((p) =>
      PublicHealthServiceCardResponseDto.fromEntity(
        p,
        partner,
        ratingsMap?.get(p.id)?.rating,
      ),
    );
  }
}
