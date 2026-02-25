import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Product } from '@/common/entities/product.entity';

// ─── Nested DTOs ─────────────────────────────────────────────

class FeatureTagDto {
  @ApiProperty({ example: 'leaf' })
  iconName: string;

  @ApiProperty({ example: 'Pain Relief' })
  label: string;
}

class ClinicDto {
  @ApiProperty({ example: 'Healytics Wellness Center' })
  name: string;

  @ApiProperty({ example: '123 Health Street, District 1, HCMC' })
  address: string;

  @ApiPropertyOptional({ example: true })
  isVerified?: boolean;
}

class SpecialistDto {
  @ApiProperty() id: string;
  @ApiProperty() name: string;
  @ApiProperty() role: string;
  @ApiPropertyOptional() imageUrl: string | null;
  @ApiPropertyOptional() degrees: string | null;
  @ApiPropertyOptional() experience: string | null;
  @ApiPropertyOptional({ type: [String] }) specializations: string[];
  @ApiPropertyOptional() bio: string | null;
  @ApiPropertyOptional() quote: string | null;
  @ApiPropertyOptional({ type: [String] }) languages: string[];
}

class TimeSlotDto {
  @ApiProperty({ example: '09:00' })
  time: string;

  @ApiProperty({ example: true })
  available: boolean;
}

class DayScheduleDto {
  @ApiProperty({ example: 'Mon' })
  day: string;

  @ApiProperty({ example: '2025-05-12' })
  date: string;

  @ApiProperty({ type: [TimeSlotDto] })
  slots: TimeSlotDto[];
}

class FacilityImageDto {
  @ApiProperty() imageUrl: string;
  @ApiProperty() label: string;
}

class ReviewDto {
  @ApiProperty() id: string;
  @ApiProperty() reviewerName: string;
  @ApiPropertyOptional() avatarUrl: string | null;
  @ApiProperty() rating: number;
  @ApiProperty() status: string;
  @ApiProperty() date: string;
  @ApiProperty() text: string;
  @ApiPropertyOptional({ type: [String] }) imageUrls: string[];
}

class RecommendedServiceDto {
  @ApiProperty() id: string;
  @ApiProperty() title: string;
  @ApiPropertyOptional() imageUrl: string | null;
  @ApiProperty() rating: number;
  @ApiProperty() reviewCount: number;
  @ApiProperty() price: string;
}

// ─── Main DTO ────────────────────────────────────────────────

export class ProductDetailResponseDto {
  @ApiProperty() id: string;
  @ApiProperty() title: string;
  @ApiProperty() categoryLabel: string;
  @ApiProperty({ type: [String] }) images: string[];
  @ApiProperty() rating: number;
  @ApiProperty() reviewCount: number;
  @ApiProperty() price: string;
  @ApiProperty() isVerified: boolean;
  @ApiPropertyOptional() description: string | null;
  @ApiProperty() duration: number;
  @ApiProperty({ type: [FeatureTagDto] }) featureTags: FeatureTagDto[];
  @ApiProperty({ type: ClinicDto }) clinic: ClinicDto;
  @ApiProperty({ type: [SpecialistDto] }) specialists: SpecialistDto[];
  @ApiProperty({ type: [DayScheduleDto] }) daySchedules: DayScheduleDto[];
  @ApiProperty({ type: [FacilityImageDto] }) facilityImages: FacilityImageDto[];
  @ApiProperty({ type: [ReviewDto] }) reviews: ReviewDto[];
  @ApiProperty({ type: [RecommendedServiceDto] }) recommendedServices: RecommendedServiceDto[];

  /**
   * Maps a Product entity + recommended products into the detail response DTO.
   */
  static fromEntity(product: Product, recommended: Product[]): ProductDetailResponseDto {
    const dto = new ProductDetailResponseDto();

    dto.id = product.slug;
    dto.title = product.name;
    dto.categoryLabel = product.category?.name ?? 'Uncategorized';
    dto.images = (product.media ?? [])
      .sort((a, b) => a.sortOrder - b.sortOrder)
      .map((m) => m.url);
    dto.description = product.description;
    dto.duration = product.serviceDefinition?.durationMinutes ?? 0;

    // Reviews & rating
    const reviews = product.reviews ?? [];
    dto.reviewCount = reviews.length;
    dto.rating = reviews.length
      ? Math.round((reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length) * 10) / 10
      : 0;

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
    dto.specialists = (product.serviceEmployeeEligibilities ?? []).map((elig) => {
      const emp = elig.employee;
      const doc = emp?.doctorProfile;
      return {
        id: emp?.id ?? '',
        name: emp?.fullName ?? '',
        role: emp?.jobTitle ?? emp?.role ?? '',
        imageUrl: emp?.avatarUrl ?? null,
        degrees: doc?.education?.join(', ') ?? null,
        experience: doc?.experienceYears ? `${doc.experienceYears} years` : null,
        specializations: doc?.specializations ?? [],
        bio: emp?.description ?? null,
        quote: emp?.description ?? null,
        languages: ['Vietnamese', 'English'], // Mocked until entity supports it
      };
    });

    // Day schedules (mocked)
    dto.daySchedules = generateMockSchedules();

    // Facility images
    dto.facilityImages = (product.facilityImages ?? [])
      .sort((a, b) => a.sortOrder - b.sortOrder)
      .map((fi) => ({
        imageUrl: fi.imageUrl,
        label: fi.label,
      }));

    // Reviews mapping
    dto.reviews = reviews.map((r) => ({
      id: r.id,
      reviewerName: r.reviewerName,
      avatarUrl: r.avatarUrl,
      rating: r.rating,
      status: r.status,
      date: r.date instanceof Date ? r.date.toISOString().split('T')[0] : String(r.date),
      text: r.text,
      imageUrls: r.imageUrls ?? [],
    }));

    // Recommended services
    dto.recommendedServices = recommended.map((p) => {
      const rPrice = p.salePrice ?? p.basePrice;
      return {
        id: p.slug,
        title: p.name,
        imageUrl: p.media?.find((m) => m.isThumbnail)?.url ?? p.media?.[0]?.url ?? null,
        rating: 0,
        reviewCount: 0,
        price: new Intl.NumberFormat('vi-VN').format(Number(rPrice)) + '₫',
      };
    });

    return dto;
  }
}

// ─── Helpers ─────────────────────────────────────────────────

function mapTagToIcon(tagName?: string): string {
  const iconMap: Record<string, string> = {
    'Pain Relief': 'healing',
    'Relaxation': 'spa',
    'Rehabilitation': 'fitness_center',
    'Beauty': 'face',
    'Skincare': 'dermatology',
  };
  return iconMap[tagName ?? ''] ?? 'local_offer';
}

function generateMockSchedules(): DayScheduleDto[] {
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
    const afternoonSlots = ['14:00', '14:30', '15:00', '15:30', '16:00', '16:30'];
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
