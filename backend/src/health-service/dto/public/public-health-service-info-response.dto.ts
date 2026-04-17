import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Product } from '@/common/entities/product.entity';
import { Partner } from '@/common/entities/partner.entity';

// ─── Nested DTOs ─────────────────────────────────────────────

class PublicFeatureTagDto {
  @ApiProperty({ type: String, example: 'schedule' })
  iconName: string;

  @ApiProperty({ type: String, example: 'Pain Relief' })
  label: string;
}

class PublicCategoryDto {
  @ApiProperty({ type: String, example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ type: String, example: 'Spa & Massage' })
  name: string;

  @ApiProperty({ type: String, example: 'spa-massage' })
  slug: string;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'https://example.com/category.jpg' })
  imageUrl: string | null;
}

class PublicClinicDto {
  @ApiProperty({ type: String, example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ type: String, example: 'Healytics Wellness Center' })
  name: string;

  @ApiPropertyOptional({ type: String, example: 'https://example.com/logo.jpg' })
    
  avatarUrl?: string;

  @ApiProperty({ type: String, example: '123 Health Street, District 1, HCMC' })
  address: string;
}

class PublicFacilityImageDto {
  @ApiProperty({ type: String, example: 'https://example.com/facility.jpg' })
  imageUrl: string;

  @ApiProperty({ type: String, example: 'Treatment Room' })
  label: string;
}

class PublicServiceTagDto {
  @ApiProperty({ type: String, example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ type: String, example: 'Pain Relief' })
  name: string;

  @ApiProperty({ type: String, example: '#FF4CAF50' })
  colorValue: string;

  @ApiPropertyOptional({ type: String, nullable: true, example: 'Pain management and relief services' })
  description: string | null;
}

// ─── Main DTO ────────────────────────────────────────────────

export class PublicHealthServiceInfoResponseDto {
  @ApiProperty({ type: String }) id: string;
  @ApiProperty({ type: String }) title: string;
  @ApiProperty({ type: PublicCategoryDto }) category: PublicCategoryDto;
  @ApiProperty({ type: [String] }) images: string[];
  @ApiProperty({ type: Number, example: 4.9 }) rating: number;
  @ApiProperty({ type: Number, example: 124 }) reviewCount: number;
  @ApiProperty({ type: String, example: '$350.00' }) price: string;
  @ApiProperty({ type: Boolean, example: true }) isVerified: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) description: string | null;
  @ApiProperty({ type: [PublicFeatureTagDto] })
  featureTags: PublicFeatureTagDto[];
  @ApiProperty({ type: PublicClinicDto }) clinic: PublicClinicDto;
  @ApiProperty({ type: [PublicFacilityImageDto] })
  facilityImages: PublicFacilityImageDto[];
  @ApiProperty({ type: [PublicServiceTagDto] })
  serviceTags: PublicServiceTagDto[];

  static fromEntity(
    product: Product,
    partner?: Partner | null,
    ratingData?: { rating: number; count: number },
  ): PublicHealthServiceInfoResponseDto {
    const dto = new PublicHealthServiceInfoResponseDto();

    dto.id = product.id;
    dto.title = product.name;
    dto.category = product.category
      ? {
          id: product.category.id,
          name: product.category.name,
          slug: product.category.slug,
          imageUrl: product.category.imageUrl,
        }
      : {
          id: '',
          name: 'Uncategorized',
          slug: 'uncategorized',
          imageUrl: null,
        };
    dto.images = (product.media ?? [])
      .sort((a, b) => a.sortOrder - b.sortOrder)
      .map((m) => m.url);
    dto.description = product.description;

    // Reviews & rating — pre-computed from TreatmentReview aggregate
    dto.reviewCount = ratingData?.count ?? 0;
    dto.rating = ratingData?.rating ?? 0;

    // Price formatting
    const price = product.salePrice ?? product.basePrice;
    dto.price = new Intl.NumberFormat('vi-VN').format(Number(price)) + '₫';

    // Derived
    dto.isVerified = product.status === 'active';

    // Feature tags
    dto.featureTags = (product.productTags ?? []).map((pt) => ({
      iconName: mapTagToIcon(pt.tag?.name),
      label: pt.tag?.name ?? 'Unknown',
    }));

    // Service tags (full tag details)
    dto.serviceTags = (product.productTags ?? []).map((pt) => ({
      id: pt.tag?.id ?? '',
      name: pt.tag?.name ?? 'Unknown',
      colorValue: pt.tag?.colorValue ?? '#FF6366F1',
      description: pt.tag?.description ?? null,
    }));

    // Clinic info from health_partner account
    if (partner) {
      const addressParts = [
        partner.streetAddress,
        partner.ward?.fullName,
        partner.district?.fullName,
        partner.province?.fullName,
      ].filter(Boolean);

      dto.clinic = {
        id: partner.id,
        name: partner.brandName,
        avatarUrl: partner.logoImageUrl!,
        address: addressParts.join(', '),
      };
    } else {
      dto.clinic = {
        id: '',
        name: 'Healytics Wellness Center',
        avatarUrl: '',
        address: '123 Health Street, District 1, Ho Chi Minh City',
      };
    }

    // Facility images
    dto.facilityImages = (product.facilityImages ?? [])
      .sort((a, b) => a.sortOrder - b.sortOrder)
      .map((fi) => ({
        imageUrl: fi.imageUrl,
        label: fi.label,
      }));

    return dto;
  }
}

// ─── Helpers ─────────────────────────────────────────────────

function mapTagToIcon(tagName?: string): string {
  const iconMap: Record<string, string> = {
    'Pain Relief': 'healing',
    Relaxation: 'spa',
    Rehabilitation: 'fitness_center',
    Beauty: 'face',
    Skincare: 'dermatology',
  };
  return iconMap[tagName ?? ''] ?? 'local_offer';
}
