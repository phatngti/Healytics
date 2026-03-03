import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Product } from '@/common/entities/product.entity';
import { Partner } from '@/common/entities/partner.entity';

/**
 * Flat product card DTO used by listing endpoints
 * (premium-treatments, home-recommend).
 */
export class PublicProductCardResponseDto {
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

  @ApiProperty({ example: '60 min' })
  duration: string;

  @ApiProperty({ example: '₫500,000' })
  price: string;

  @ApiProperty({ example: '4.9' })
  rating: string;

  @ApiProperty({ example: 'Healytics Spa' })
  vendorName: string;

  @ApiProperty({ example: 'District 1, HCMC' })
  location: string;

  @ApiProperty({ type: [String], example: ['https://example.com/avatar1.jpg'] })
  staffAvatars: string[];

  @ApiProperty({ example: 'service' })
  type: string;

  static fromEntity(
    product: Product,
    partner?: Partner | null,
  ): PublicProductCardResponseDto {
    const dto = new PublicProductCardResponseDto();

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

    // Duration from product definition
    const minutes = product.productDefinition?.durationMinutes;
    dto.duration = minutes ? `${minutes} min` : '';

    // Price formatting (Vietnamese đồng)
    const price = product.salePrice ?? product.basePrice;
    dto.price = '₫' + new Intl.NumberFormat('vi-VN').format(Number(price));

    // Average rating from reviews
    const reviews = product.reviews ?? [];
    const avg = reviews.length
      ? reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length
      : 0;
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
    partner?: Partner | null,
  ): PublicProductCardResponseDto[] {
    return products.map((p) => PublicProductCardResponseDto.fromEntity(p, partner));
  }
}
