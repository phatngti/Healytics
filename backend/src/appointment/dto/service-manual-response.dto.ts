import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { Booking } from '@/common/entities/booking.entity';

// ── Nested Sub-DTOs ──────────────────────────────────────────

export class ServiceRuleDto {
  @ApiProperty({ example: 'no-eating' })
  @Expose()
  iconSlug: string;

  @ApiProperty({ example: 'No Eating Before' })
  @Expose()
  title: string;

  @ApiProperty({ example: 'Avoid eating 2 hours before the service' })
  @Expose()
  description: string;
}

export class ProcedureStepDto {
  @ApiProperty({ example: 1 })
  @Expose()
  stepNumber: number;

  @ApiProperty({ example: 'Check-in & Registration' })
  @Expose()
  title: string;

  @ApiProperty({ example: 'Arrive at the reception and complete registration' })
  @Expose()
  description: string;

  @ApiProperty({ example: false })
  @Expose()
  isActive: boolean;
}

export class FacilityDto {
  @ApiProperty({ example: 'https://example.com/facility.jpg' })
  @Expose()
  imageUrl: string;

  @ApiProperty({ example: 'Sauna Room' })
  @Expose()
  name: string;
}

export class ReviewSummaryDto {
  @ApiProperty({ example: 4.8 })
  @Expose()
  averageRating: number;

  @ApiProperty({ example: 'Jane Doe' })
  @Expose()
  reviewerName: string;

  @ApiProperty({ example: 'Excellent service! Very relaxing.' })
  @Expose()
  reviewText: string;

  @ApiProperty({ example: 5 })
  @Expose()
  starCount: number;
}

// ── Main Response DTO ────────────────────────────────────────

export class ServiceManualResponseDto {
  @ApiProperty({ example: 'Thai Massage' })
  @Expose()
  serviceName: string;

  @ApiProperty({ example: 'Healytics Spa Center' })
  @Expose()
  vendorName: string;

  @ApiProperty({ example: 'https://example.com/image.jpg' })
  @Expose()
  imageUrl: string;

  @ApiProperty({ type: [String], example: ['Avoid heavy meals', 'Wear comfortable clothing'] })
  @Expose()
  preServiceGuidelines: string[];

  @ApiProperty({ type: [ServiceRuleDto] })
  @Expose()
  @Type(() => ServiceRuleDto)
  serviceRules: ServiceRuleDto[];

  @ApiProperty({ type: [ProcedureStepDto] })
  @Expose()
  @Type(() => ProcedureStepDto)
  procedureSteps: ProcedureStepDto[];

  @ApiProperty({ type: [FacilityDto] })
  @Expose()
  @Type(() => FacilityDto)
  facilities: FacilityDto[];

  @ApiPropertyOptional({ type: ReviewSummaryDto })
  @Expose()
  @Type(() => ReviewSummaryDto)
  review: ReviewSummaryDto | null;

  static fromBooking(booking: Booking): ServiceManualResponseDto {
    const dto = new ServiceManualResponseDto();
    const product = booking.product;

    dto.serviceName = product?.name ?? 'Unknown Service';
    dto.vendorName = product?.vendorName ?? '';
    dto.imageUrl = product?.media?.[0]?.url ?? '';

    // Pre-service guidelines — use stored data or fallback to description
    const manual = product?.serviceManual;
    dto.preServiceGuidelines = manual?.preServiceGuidelines
      ?? (product?.description
        ? product.description.split('\n').filter((line) => line.trim().length > 0)
        : []);

    // Service rules — use stored data or return empty array
    dto.serviceRules = manual?.serviceRules ?? [];

    // Procedure steps — use stored data or create defaults from definition
    const durationMinutes = product?.productDefinition?.durationMinutes;
    dto.procedureSteps = manual?.procedureSteps?.map((s) => ({ ...s, isActive: false }))
      ?? [
        {
          stepNumber: 1,
          title: 'Check-in & Registration',
          description: 'Arrive at the reception and complete registration',
          isActive: false,
        },
        {
          stepNumber: 2,
          title: 'Service Session',
          description: durationMinutes
            ? `Enjoy your ${durationMinutes}-minute session`
            : 'Enjoy your service session',
          isActive: false,
        },
        {
          stepNumber: 3,
          title: 'Post-Service',
          description: 'Relax and receive aftercare instructions',
          isActive: false,
        },
      ];

    // Facilities from facility images
    dto.facilities = (product?.facilityImages ?? []).map((fi) => ({
      imageUrl: fi.imageUrl,
      name: fi.label,
    }));

    // Review summary — product_reviews table dropped; no review summary available
    dto.review = null;

    return dto;
  }
}
