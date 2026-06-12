import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Partner } from '@/common/entities/partner.entity';

// ─── Nested DTOs ─────────────────────────────────────────────

export class BookingScheduleDto {
  @ApiPropertyOptional({ example: '2024-05-20T00:00:00.000Z' })
  date: string | null;

  @ApiPropertyOptional({ example: '09:00 AM - 10:00 AM' })
  timeSlotLabel: string | null;
}

export class SpecialistInfoDto {
  @ApiProperty({ example: 'spec-12345' })
  id: string;

  @ApiProperty({ example: 'Dr. Sarah Jenkins' })
  name: string;

  @ApiPropertyOptional({ example: 'Dermatologist' })
  specialty: string | null;

  @ApiPropertyOptional({ example: 'https://example.com/avatars/sarah.jpg' })
  avatarUrl: string | null;
}

export class ServiceInfoDto {
  @ApiProperty({ example: 'srv-98765' })
  id: string;

  @ApiProperty({ example: 'Comprehensive Skin Assessment' })
  title: string;

  @ApiPropertyOptional({
    example: 'Full body mole mapping and skin health check',
  })
  subtitle: string | null;

  @ApiProperty({ example: '45 min' })
  duration: string;

  @ApiPropertyOptional({
    example: 'https://example.com/services/skin-assessment.jpg',
  })
  imageUrl: string | null;
}

export class CategoryInfoDto {
  @ApiProperty({ example: 'cat-555' })
  id: string;

  @ApiPropertyOptional({ example: 'root-cat-111', nullable: true })
  parentCategoryId: string | null;

  @ApiProperty({ example: 'Dermatology' })
  name: string;

  @ApiPropertyOptional({ example: 'Spa & Beauty', nullable: true })
  parentCategoryName: string | null;
}

export class LocationInfoDto {
  @ApiProperty({ example: 'Healytics Main Center' })
  name: string;

  @ApiProperty({ example: '123 Wellness Avenue, Ho Chi Minh City' })
  address: string;

  @ApiPropertyOptional({ example: 'https://maps.example.com/...' })
  mapUrl: string | null;

  @ApiPropertyOptional({ example: 10.7758, nullable: true, type: Number })
  latitude: number | null;

  @ApiPropertyOptional({ example: 106.7009, nullable: true, type: Number })
  longitude: number | null;
}

export class PriceBreakdownDto {
  @ApiProperty({ example: 500000 })
  subTotal: number;

  @ApiProperty({ example: 50000 })
  discount: number;

  @ApiProperty({ example: 450000 })
  totalAmount: number;

  @ApiProperty({ example: 'VND' })
  currency: string;
}

// ─── Main DTO ────────────────────────────────────────────────

export class UserEligibilityDetailResponseDto {
  @ApiProperty({ example: true })
  isCompletedStep: boolean;

  @ApiPropertyOptional({ type: BookingScheduleDto })
  bookingSchedule: BookingScheduleDto | null;

  @ApiProperty({ type: SpecialistInfoDto })
  specialist: SpecialistInfoDto;

  @ApiProperty({ type: ServiceInfoDto })
  service: ServiceInfoDto;

  @ApiProperty({ type: CategoryInfoDto })
  category: CategoryInfoDto;

  @ApiProperty({ type: LocationInfoDto })
  location: LocationInfoDto;

  @ApiProperty({ type: PriceBreakdownDto })
  priceBreakdown: PriceBreakdownDto;

  /**
   * Factory: maps a fully-loaded ProductEmployeeEligibility entity to the DTO.
   * Requires relations: product, product.partner, product.category,
   * product.media, product.productDefinition, employee, employee.doctorProfile
   */
  static fromEntity(
    eligibility: ProductEmployeeEligibility,
    partner: Partner | null,
  ): UserEligibilityDetailResponseDto {
    const dto = new UserEligibilityDetailResponseDto();
    const { product, employee } = eligibility;
    const doc = employee?.doctorProfile ?? null;

    dto.isCompletedStep = true; // Default true as requested template
    dto.bookingSchedule = null; // No booking selected yet for pure eligibility

    // ── Specialist ───────────────────────────────────────────
    dto.specialist = {
      id: employee?.id ?? '',
      name: employee?.fullName ?? '',
      specialty: doc?.specializations?.[0] ?? employee?.jobTitle ?? null,
      avatarUrl: employee?.avatarUrl ?? null,
    };

    // ── Service ──────────────────────────────────────────────
    const sortedMedia = (product?.media ?? []).sort(
      (a, b) => a.sortOrder - b.sortOrder,
    );
    const durationMins = product?.productDefinition?.durationMinutes ?? 0;

    dto.service = {
      id: product?.id ?? '',
      title: product?.name ?? '',
      subtitle: product?.description ?? null,
      duration: `${durationMins} min`,
      imageUrl: sortedMedia[0]?.url ?? null,
    };

    // ── Category ─────────────────────────────────────────────
    dto.category = {
      id: product?.category?.id ?? '',
      parentCategoryId: product?.category?.parent?.id ?? null,
      name: product?.category?.name ?? 'Uncategorized',
      parentCategoryName: product?.category?.parent?.name ?? null,
    };

    // ── Location ─────────────────────────────────────────────
    if (partner) {
      const addressParts = [
        partner.streetAddress,
        partner.ward?.fullName,
        partner.district?.fullName,
        partner.province?.fullName,
      ].filter(Boolean);

      dto.location = {
        name: partner.brandName,
        address: addressParts.join(', '),
        mapUrl: null, // Depending on if we have it in partner. For now null
        latitude: partner.latitude,
        longitude: partner.longitude,
      };
    } else {
      dto.location = {
        name: 'Healytics Wellness Center',
        address: '123 Health Street, District 1, Ho Chi Minh City',
        mapUrl: null,
        latitude: null,
        longitude: null,
      };
    }

    // ── Price Breakdown ──────────────────────────────────────
    const subTotal = Number(product?.basePrice ?? 0);
    const salePrice =
      product?.salePrice != null ? Number(product.salePrice) : null;
    const totalAmount = salePrice ?? subTotal;
    const discount = subTotal - totalAmount;

    dto.priceBreakdown = {
      subTotal,
      discount: discount > 0 ? discount : 0,
      totalAmount,
      currency: product?.currency ?? 'VND',
    };

    return dto;
  }
}
