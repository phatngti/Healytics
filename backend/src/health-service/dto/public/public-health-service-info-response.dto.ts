import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Product } from '@/common/entities/product.entity';
import { Partner } from '@/common/entities/partner.entity';

// ─── Nested DTOs ─────────────────────────────────────────────

class PublicFeatureTagDto {
  @ApiProperty({ example: 'schedule' })
  iconName: string;

  @ApiProperty({ example: 'Pain Relief' })
  label: string;
}

class PublicCategoryDto {
  @ApiProperty({ example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ example: 'Spa & Massage' })
  name: string;

  @ApiProperty({ example: 'spa-massage' })
  slug: string;

  @ApiPropertyOptional({ example: 'https://example.com/category.jpg' })
  imageUrl: string | null;
}

class PublicClinicDto {
  @ApiProperty({ example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ example: 'Healytics Wellness Center' })
  name: string;

  @ApiProperty({ example: '123 Health Street, District 1, HCMC' })
  address: string;
}

class PublicFacilityImageDto {
  @ApiProperty({ example: 'https://example.com/facility.jpg' })
  imageUrl: string;

  @ApiProperty({ example: 'Treatment Room' })
  label: string;
}

class PublicServiceTagDto {
  @ApiProperty({ example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ example: 'Pain Relief' })
  name: string;

  @ApiProperty({ example: '#FF4CAF50' })
  colorValue: string;

  @ApiPropertyOptional({ example: 'Pain management and relief services' })
  description: string | null;
}

// ─── Main DTO ────────────────────────────────────────────────

export class PublicHealthServiceInfoResponseDto {
  @ApiProperty() id: string;
  @ApiProperty() title: string;
  @ApiProperty({ type: PublicCategoryDto }) category: PublicCategoryDto;
  @ApiProperty({ type: [String] }) images: string[];
  @ApiProperty({ example: 4.9 }) rating: number;
  @ApiProperty({ example: 124 }) reviewCount: number;
  @ApiProperty({ example: '$350.00' }) price: string;
  @ApiProperty({ example: true }) isVerified: boolean;
  @ApiPropertyOptional() description: string | null;
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
        address: addressParts.join(', '),
      };
    } else {
      dto.clinic = {
        id: '',
        name: 'Healytics Wellness Center',
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
