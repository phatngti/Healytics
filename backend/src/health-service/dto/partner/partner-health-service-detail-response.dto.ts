import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Product } from '@/common/entities/product.entity';

// ─── Nested DTOs ─────────────────────────────────────────────

class PartnerFeatureTagDto {
  @ApiProperty({ type: String, example: 'leaf' })
  iconName: string;

  @ApiProperty({ type: String, example: 'Pain Relief' })
  label: string;
}

class PartnerClinicDto {
  @ApiProperty({ type: String, example: 'Healytics Wellness Center' })
  name: string;

  @ApiProperty({ type: String, example: '123 Health Street, District 1, HCMC' })
  address: string;

  @ApiPropertyOptional({ type: Boolean, example: true })
  isVerified?: boolean;
}

class PartnerSpecialistDto {
  @ApiProperty({ type: String }) id: string;
  @ApiProperty({ type: String }) name: string;
  @ApiProperty({ type: String }) role: string;
  @ApiPropertyOptional({ type: String, nullable: true }) imageUrl:
    | string
    | null;
  @ApiPropertyOptional({ type: String, nullable: true }) degrees: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) experience:
    | string
    | null;
  @ApiPropertyOptional({ type: [String] }) specializations: string[];
  @ApiPropertyOptional({ type: String, nullable: true }) bio: string | null;
  @ApiPropertyOptional({ type: String, nullable: true }) quote: string | null;
  @ApiPropertyOptional({ type: [String] }) languages: string[];
}

class PartnerTimeSlotDto {
  @ApiProperty({ type: String, example: '09:00' })
  time: string;

  @ApiProperty({ type: Boolean, example: true })
  available: boolean;
}

class PartnerDayScheduleDto {
  @ApiProperty({ type: String, example: 'Mon' })
  day: string;

  @ApiProperty({ type: String, example: '2025-05-12' })
  date: string;

  @ApiProperty({ type: [PartnerTimeSlotDto] })
  slots: PartnerTimeSlotDto[];
}

class PartnerFacilityImageDto {
  @ApiProperty({ type: String }) imageUrl: string;
  @ApiProperty({ type: String }) label: string;
}

class PartnerReviewDto {
  @ApiProperty({ type: String }) id: string;
  @ApiProperty({ type: String }) reviewerName: string;
  @ApiPropertyOptional({ type: String, nullable: true }) avatarUrl:
    | string
    | null;
  @ApiProperty({ type: Number }) rating: number;
  @ApiProperty({ type: String }) status: string;
  @ApiProperty({ type: String }) date: string;
  @ApiProperty({ type: String }) text: string;
  @ApiPropertyOptional({ type: [String] }) imageUrls: string[];
}

class PartnerRecommendedServiceDto {
  @ApiProperty({ type: String }) id: string;
  @ApiProperty({ type: String }) title: string;
  @ApiPropertyOptional({ type: String, nullable: true }) imageUrl:
    | string
    | null;
  @ApiProperty({ type: Number }) rating: number;
  @ApiProperty({ type: Number }) reviewCount: number;
  @ApiProperty({ type: String }) price: string;
}

class PartnerDetailServiceRuleDto {
  @ApiProperty({ type: String, example: 'no-eating' }) iconSlug: string;
  @ApiProperty({ type: String, example: 'No Eating Before' }) title: string;
  @ApiProperty({
    type: String,
    example: 'Avoid eating 2 hours before the service',
  })
  description: string;
}

class PartnerDetailProcedureStepDto {
  @ApiProperty({ type: Number, example: 1 }) stepNumber: number;
  @ApiProperty({ type: String, example: 'Check-in & Registration' })
  title: string;
  @ApiProperty({
    type: String,
    example: 'Arrive at the reception and complete registration',
  })
  description: string;
}

class PartnerDetailServiceManualDto {
  @ApiPropertyOptional({ type: [String] }) preServiceGuidelines?: string[];
  @ApiPropertyOptional({ type: [PartnerDetailServiceRuleDto] })
  serviceRules?: PartnerDetailServiceRuleDto[];
  @ApiPropertyOptional({ type: [PartnerDetailProcedureStepDto] })
  procedureSteps?: PartnerDetailProcedureStepDto[];
}

// ─── Main DTO ────────────────────────────────────────────────

export class PartnerHealthServiceDetailResponseDto {
  @ApiProperty({ type: String }) id: string;
  @ApiProperty({ type: String }) title: string;
  @ApiProperty({ type: String }) categoryLabel: string;
  @ApiProperty({ type: [String] }) images: string[];
  @ApiProperty({ type: Number }) rating: number;
  @ApiProperty({ type: Number }) reviewCount: number;
  @ApiProperty({ type: String }) price: string;
  @ApiProperty({ type: Boolean }) isVerified: boolean;
  @ApiPropertyOptional({ type: String, nullable: true }) description:
    | string
    | null;
  @ApiProperty({ type: Number }) duration: number;
  @ApiProperty({ type: [PartnerFeatureTagDto] })
  featureTags: PartnerFeatureTagDto[];
  @ApiProperty({ type: PartnerClinicDto }) clinic: PartnerClinicDto;
  @ApiProperty({ type: [PartnerSpecialistDto] })
  specialists: PartnerSpecialistDto[];
  @ApiProperty({ type: [PartnerDayScheduleDto] })
  daySchedules: PartnerDayScheduleDto[];
  @ApiProperty({ type: [PartnerFacilityImageDto] })
  facilityImages: PartnerFacilityImageDto[];
  @ApiProperty({ type: [PartnerReviewDto] }) reviews: PartnerReviewDto[];
  @ApiProperty({ type: [PartnerRecommendedServiceDto] })
  recommendedServices: PartnerRecommendedServiceDto[];
  @ApiPropertyOptional({ type: PartnerDetailServiceManualDto, nullable: true })
  serviceManual: PartnerDetailServiceManualDto | null;

  /**
   * Maps a Product entity + recommended products into the detail response DTO.
   */
  static fromEntity(
    product: Product,
    recommended: Product[],
  ): PartnerHealthServiceDetailResponseDto {
    const dto = new PartnerHealthServiceDetailResponseDto();

    dto.id = product.slug;
    dto.title = product.name;
    dto.categoryLabel = product.category?.name ?? 'Uncategorized';
    dto.images = (product.media ?? [])
      .sort((a, b) => a.sortOrder - b.sortOrder)
      .map((m) => m.url);
    dto.description = product.description;
    dto.duration = product.productDefinition?.durationMinutes ?? 0;

    // Reviews & rating — product_reviews table dropped; fetched separately from product_treatment_reviews
    dto.reviewCount = 0;
    dto.rating = 0;

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

    // Clinic (mocked until branch/location module exists)
    dto.clinic = {
      name: 'Healytics Wellness Center',
      address: '123 Health Street, District 1, Ho Chi Minh City',
      isVerified: true,
    };

    // Specialists
    dto.specialists = (product.productEmployeeEligibilities ?? []).map(
      (elig) => {
        const emp = elig.employee;
        const doc = emp?.doctorProfile;
        return {
          id: emp?.id ?? '',
          name: emp?.fullName ?? '',
          role: emp?.jobTitle ?? emp?.role ?? '',
          imageUrl: emp?.avatarUrl ?? null,
          degrees: doc?.education?.join(', ') ?? null,
          experience: doc?.experienceYears
            ? `${doc.experienceYears} years`
            : null,
          specializations: doc?.specializations ?? [],
          bio: emp?.description ?? null,
          quote: emp?.description ?? null,
          languages: ['Vietnamese', 'English'], // Mocked until entity supports it
        };
      },
    );

    // Day schedules (mocked)
    dto.daySchedules = generateMockSchedules();

    // Facility images
    dto.facilityImages = (product.facilityImages ?? [])
      .sort((a, b) => a.sortOrder - b.sortOrder)
      .map((fi) => ({
        imageUrl: fi.imageUrl,
        label: fi.label,
      }));

    // Reviews — empty; use GET /reviews endpoint to fetch real TreatmentReview data
    dto.reviews = [];

    // Recommended services
    dto.recommendedServices = recommended.map((p) => {
      const rPrice = p.salePrice ?? p.basePrice;
      return {
        id: p.slug,
        title: p.name,
        imageUrl:
          p.media?.find((m) => m.isThumbnail)?.url ?? p.media?.[0]?.url ?? null,
        rating: 0,
        reviewCount: 0,
        price: new Intl.NumberFormat('vi-VN').format(Number(rPrice)) + '₫',
      };
    });

    // Service manual
    dto.serviceManual = product.serviceManual ?? null;

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

function generateMockSchedules(): PartnerDayScheduleDto[] {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const baseDate = new Date();
  // Start from next Monday
  const dayOfWeek = baseDate.getDay();
  const daysUntilMonday = dayOfWeek === 0 ? 1 : 8 - dayOfWeek;
  baseDate.setDate(baseDate.getDate() + daysUntilMonday);

  return days.map((day, i) => {
    const date = new Date(baseDate);
    date.setDate(date.getDate() + i);
    const dateStr = date.toISOString().split('T')[0];

    const morningSlots = ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30'];
    const afternoonSlots = [
      '14:00',
      '14:30',
      '15:00',
      '15:30',
      '16:00',
      '16:30',
    ];
    const allSlots = [...morningSlots, ...afternoonSlots];

    return {
      day,
      date: dateStr,
      slots: allSlots.map((time) => ({
        time,
        available: Math.random() > 0.3, // ~70% availability
      })),
    };
  });
}
