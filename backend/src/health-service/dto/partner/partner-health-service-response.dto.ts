import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { HealthServiceType } from '../../enums/health-service-type.enum';
import { HealthServiceStatus } from '../../enums/health-service-status.enum';

// ─── Service Manual Sub-DTOs ─────────────────────────────────

class PartnerServiceRuleDto {
  @Expose()
  @ApiProperty({ example: 'no-eating' })
  iconSlug: string;

  @Expose()
  @ApiProperty({ example: 'No Eating Before' })
  title: string;

  @Expose()
  @ApiProperty({ example: 'Avoid eating 2 hours before the service' })
  description: string;
}

class PartnerProcedureStepDto {
  @Expose()
  @ApiProperty({ example: 1 })
  stepNumber: number;

  @Expose()
  @ApiProperty({ example: 'Check-in & Registration' })
  title: string;

  @Expose()
  @ApiProperty({ example: 'Arrive at the reception and complete registration' })
  description: string;
}

class PartnerServiceManualDto {
  @Expose()
  @ApiPropertyOptional({ type: [String], example: ['Avoid heavy meals', 'Wear comfortable clothing'] })
  preServiceGuidelines?: string[];

  @Expose()
  @Type(() => PartnerServiceRuleDto)
  @ApiPropertyOptional({ type: [PartnerServiceRuleDto] })
  serviceRules?: PartnerServiceRuleDto[];

  @Expose()
  @Type(() => PartnerProcedureStepDto)
  @ApiPropertyOptional({ type: [PartnerProcedureStepDto] })
  procedureSteps?: PartnerProcedureStepDto[];
}

/**
 * Response DTO for category data within health service.
 */
class PartnerCategorySummaryDto {
  @Expose()
  @ApiProperty()
  id: string;

  @Expose()
  @ApiProperty()
  name: string;

  @Expose()
  @ApiProperty()
  slug: string;
}

/**
 * Response DTO for health service media.
 * Matches ProductMedia entity structure.
 */
class PartnerHealthServiceMediaDto {
  @Expose()
  @ApiProperty({ description: 'Unique media identifier' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'Media URL' })
  url: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Media type (image, video, etc.)' })
  mediaType?: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Whether this is the thumbnail' })
  isThumbnail?: boolean;

  @Expose()
  @ApiProperty({ description: 'Sort order for display' })
  sortOrder: number;
}

/**
 * Response DTO for health service definition.
 * Matches ProductDefinition entity structure.
 */
class PartnerHealthServiceDefinitionDto {
  @Expose()
  @ApiProperty({ description: 'Product ID (primary key)' })
  productId: string;

  @Expose()
  @ApiProperty({ description: 'Service duration in minutes' })
  durationMinutes: number;

  @Expose()
  @ApiPropertyOptional({ description: 'Buffer time between appointments' })
  bufferMinutes?: number;

  @Expose()
  @ApiPropertyOptional({ description: 'Maximum capacity per slot' })
  maxCapacity?: number;

  @Expose()
  @ApiPropertyOptional({ description: 'Minimum lead time for booking (hours)' })
  minLeadTimeHours?: number;

  @Expose()
  @ApiPropertyOptional({ description: 'Staff assignment type' })
  staffAssignmentType?: string;
}

/**
 * Response DTO for employee eligibility within health service.
 * Matches ProductEmployeeEligibility entity structure.
 */
class PartnerHealthServiceEmployeeEligibilityDto {
  @Expose()
  @ApiProperty({ description: 'Product ID' })
  productId: string;

  @Expose()
  @ApiProperty({ description: 'Employee ID' })
  employeeId: string;

  @Expose()
  @ApiProperty({ description: 'Whether this is the primary employee' })
  isPrimary: boolean;
}

/**
 * Health service response DTO for API responses.
 * Never expose raw entity data directly.
 */
export class PartnerHealthServiceResponseDto {
  @Expose()
  @ApiProperty({ description: 'Unique identifier' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'Name' })
  name: string;

  @Expose()
  @ApiProperty({ description: 'URL-friendly slug' })
  slug: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Description' })
  description: string | null;

  @Expose()
  @ApiProperty({ enum: HealthServiceType, description: 'Type' })
  type: HealthServiceType;

  @Expose()
  @ApiProperty({ description: 'Base price in specified currency' })
  basePrice: number;

  @Expose()
  @ApiPropertyOptional({ description: 'Sale price if on discount' })
  salePrice: number | null;

  @Expose()
  @ApiProperty({ description: 'Currency code (ISO 4217)' })
  currency: string;

  @Expose()
  @ApiProperty({ enum: HealthServiceStatus, description: 'Status' })
  status: HealthServiceStatus;

  @Expose()
  @ApiProperty({ description: 'Whether visible online' })
  isVisibleOnline: boolean;

  @Expose()
  @ApiPropertyOptional({ description: 'Vendor name' })
  vendorName: string | null;

  @Expose()
  @ApiProperty({ description: 'Creation timestamp' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ description: 'Last update timestamp' })
  updatedAt: Date;

  @Expose()
  @Type(() => PartnerCategorySummaryDto)
  @ApiPropertyOptional({ type: PartnerCategorySummaryDto, description: 'Category' })
  category: PartnerCategorySummaryDto | null;

  @Expose()
  @Type(() => PartnerHealthServiceMediaDto)
  @ApiPropertyOptional({ type: [PartnerHealthServiceMediaDto], description: 'Media assets' })
  media: PartnerHealthServiceMediaDto[];

  @Expose()
  @Type(() => PartnerHealthServiceDefinitionDto)
  @ApiPropertyOptional({ type: PartnerHealthServiceDefinitionDto, description: 'Definition for service type' })
  productDefinition: PartnerHealthServiceDefinitionDto | null;

  @Expose()
  @Type(() => PartnerHealthServiceEmployeeEligibilityDto)
  @ApiPropertyOptional({ type: [PartnerHealthServiceEmployeeEligibilityDto], description: 'Eligible employees for service' })
  productEmployeeEligibilities: PartnerHealthServiceEmployeeEligibilityDto[];

  @Expose()
  @Type(() => PartnerServiceManualDto)
  @ApiPropertyOptional({ type: PartnerServiceManualDto, description: 'Service manual (guidelines, rules, procedure steps)' })
  serviceManual: PartnerServiceManualDto | null;
}
