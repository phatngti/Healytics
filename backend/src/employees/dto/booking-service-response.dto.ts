import { Expose } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Product } from '@/common/entities/product.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { Partner } from '@/common/entities/partner.entity';

/**
 * Formats a price in VND with thousand-separator dots.
 */
function formatVnd(price: number): string {
  return `${price.toLocaleString('vi-VN')} VND`;
}

/**
 * Calculates distance between two lat/lng points in km (Haversine formula).
 */
function haversineKm(
  lat1: number,
  lng1: number,
  lat2: number,
  lng2: number,
): number {
  const R = 6371;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLng = ((lng2 - lng1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLng / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

/**
 * v2 Service response DTO for the booking flow.
 * Used by both "services by category" (Step 1) and "services by specialist" (API 5).
 */
export class BookingServiceResponseDto {
  @Expose()
  @ApiProperty({ description: 'Service/Product UUID' })
  id: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Service image URL', nullable: true })
  imageUrl: string | null;

  @Expose()
  @ApiProperty({ description: 'Service name', example: 'Deep Tissue Massage' })
  title: string;

  @Expose()
  @ApiProperty({ description: 'Formatted duration', example: '60 min' })
  duration: string;

  @Expose()
  @ApiProperty({ description: 'Formatted price', example: '850,000 VND' })
  price: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Clinic or facility name', nullable: true })
  clinicName: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Clinic street address', nullable: true })
  clinicAddress: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Distance from user (e.g. "1.2 km")', nullable: true })
  distance: string | null;

  // --- Structured fields for frontend flexibility ---

  @Expose()
  @ApiPropertyOptional({ description: 'Duration in minutes', example: 60 })
  durationMinutes: number | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Raw price in VND', example: 850000 })
  priceVnd: number | null;

  /**
   * Maps a Product entity → BookingServiceResponseDto.
   * @param product  The product entity (with media + productDefinition loaded)
   * @param partner  The health partner (for clinic info) — nullable
   * @param userLat  User's latitude for distance calc — optional
   * @param userLng  User's longitude for distance calc — optional
   */
  static fromEntity(
    product: Product,
    partner?: Partner | null,
    userLat?: number | null,
    userLng?: number | null,
  ): BookingServiceResponseDto {
    const dto = new BookingServiceResponseDto();
    dto.id = product.id;
    dto.title = product.name;

    // Image: prefer thumbnail, fall back to first media
    const media = product.media ?? [];
    const thumbnail = media.find((m) => m.isThumbnail);
    dto.imageUrl = thumbnail?.url ?? media[0]?.url ?? null;

    // Duration
    const definition = product.productDefinition;
    const mins = definition?.durationMinutes ?? null;
    dto.durationMinutes = mins;
    dto.duration = mins ? `${mins} min` : '';

    // Price
    const rawPrice = product.salePrice ?? product.basePrice ?? null;
    const numPrice = rawPrice ? Number(rawPrice) : null;
    dto.priceVnd = numPrice;
    dto.price = numPrice ? formatVnd(numPrice) : '';

    // Clinic info from partner
    dto.clinicName = partner?.brandName ?? null;
    dto.clinicAddress = partner?.streetAddress ?? null;

    // Distance calculation
    dto.distance = null;
    if (
      userLat != null &&
      userLng != null &&
      partner?.latitude != null &&
      partner?.longitude != null
    ) {
      const km = haversineKm(userLat, userLng, partner.latitude, partner.longitude);
      dto.distance = `${km.toFixed(1)} km`;
    }

    return dto;
  }

  static fromEntities(
    products: Product[],
    partner?: Partner | null,
    userLat?: number | null,
    userLng?: number | null,
  ): BookingServiceResponseDto[] {
    return products.map((p) => this.fromEntity(p, partner, userLat, userLng));
  }
}
