import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { HealthServiceType } from '../../enums/health-service-type.enum';
import { HealthServiceStatus } from '../../enums/health-service-status.enum';

// ─── Service Manual Sub-DTOs ─────────────────────────────────

class PartnerServiceRuleDto {
  @Expose()
  @ApiProperty({ type: String, example: 'no-eating' })
  iconSlug: string;

  @Expose()
  @ApiProperty({ type: String, example: 'No Eating Before' })
  title: string;

  @Expose()
  @ApiProperty({
    type: String,
    example: 'Avoid eating 2 hours before the service',
  })
  description: string;
}

class PartnerProcedureStepDto {
  @Expose()
  @ApiProperty({ type: Number, example: 1 })
  stepNumber: number;

  @Expose()
  @ApiProperty({ type: String, example: 'Check-in & Registration' })
  title: string;

  @Expose()
  @ApiProperty({
    type: String,
    example: 'Arrive at the reception and complete registration',
  })
  description: string;
}

class PartnerServiceManualDto {
  @Expose()
  @ApiPropertyOptional({
    type: [String],
    example: ['Avoid heavy meals', 'Wear comfortable clothing'],
  })
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
  @ApiProperty({ type: String })
  id: string;

  @Expose()
  @ApiProperty({ type: String })
  name: string;

  @Expose()
  @ApiProperty({ type: String })
  slug: string;
}

/**
 * Response DTO for health service media.
 * Matches ProductMedia entity structure.
 */
class PartnerHealthServiceMediaDto {
  @Expose()
  @ApiProperty({ type: String, description: 'Unique media identifier' })
  id: string;

  @Expose()
  @ApiProperty({ type: String, description: 'Media URL' })
  url: string;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    description: 'Media type (image, video, etc.)',
  })
  mediaType?: string;

  @Expose()
  @ApiPropertyOptional({
    type: Boolean,
    description: 'Whether this is the thumbnail',
  })
  isThumbnail?: boolean;

  @Expose()
  @ApiProperty({ type: Number, description: 'Sort order for display' })
  sortOrder: number;
}

/**
 * Response DTO for health service definition.
 * Matches ProductDefinition entity structure.
 */
class PartnerHealthServiceDefinitionDto {
  @Expose()
  @ApiProperty({ type: String, description: 'Product ID (primary key)' })
  productId: string;

  @Expose()
  @ApiProperty({ type: Number, description: 'Service duration in minutes' })
  durationMinutes: number;

  @Expose()
  @ApiPropertyOptional({
    type: Number,
    description: 'Buffer time between appointments',
  })
  bufferMinutes?: number;

  @Expose()
  @ApiPropertyOptional({
    type: Number,
    description: 'Maximum capacity per slot',
  })
  maxCapacity?: number;

  @Expose()
  @ApiPropertyOptional({
    type: Number,
    description: 'Minimum lead time for booking (hours)',
  })
  minLeadTimeHours?: number;

  @Expose()
  @ApiPropertyOptional({ type: String, description: 'Staff assignment type' })
  staffAssignmentType?: string;
}

/**
 * Response DTO for employee eligibility within health service.
 * Matches ProductEmployeeEligibility entity structure.
 */
class PartnerHealthServiceEmployeeEligibilityDto {
  @Expose()
  @ApiProperty({ type: String, description: 'Product ID' })
  productId: string;

  @Expose()
  @ApiProperty({ type: String, description: 'Employee ID' })
  employeeId: string;

  @Expose()
  @ApiProperty({
    type: Boolean,
    description: 'Whether this is the primary employee',
  })
  isPrimary: boolean;
}

class PartnerProductTagDetailDto {
  @Expose()
  @ApiProperty({ type: String })
  id: string;

  @Expose()
  @ApiProperty({ type: String })
  name: string;

  @Expose()
  @ApiPropertyOptional({ type: String, nullable: true })
  description: string | null;

  @Expose()
  @ApiProperty({ type: String })
  colorValue: string;
}

/**
 * Compact representation of a product–tag junction with tag details.
 */
class PartnerProductTagDto {
  @Expose()
  @ApiProperty({ type: String, description: 'Tag ID' })
  tagId: string;

  @Expose()
  @Type(() => PartnerProductTagDetailDto)
  @ApiPropertyOptional({
    type: PartnerProductTagDetailDto,
    description: 'Tag detail',
  })
  tag: PartnerProductTagDetailDto | null;
}

/**
 * Health service response DTO for API responses.
 * Never expose raw entity data directly.
 */
export class PartnerHealthServiceResponseDto {
  @Expose()
  @ApiProperty({ type: String, description: 'Unique identifier' })
  id: string;

  @Expose()
  @ApiProperty({ type: String, description: 'Name' })
  name: string;

  @Expose()
  @ApiProperty({ type: String, description: 'URL-friendly slug' })
  slug: string;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Description',
  })
  description: string | null;

  @Expose()
  @ApiProperty({
    enum: HealthServiceType,
    enumName: 'HealthServiceType',
    description: 'Type',
  })
  type: HealthServiceType;

  @Expose()
  @ApiProperty({
    type: Number,
    description: 'Base price in specified currency',
  })
  basePrice: number;

  @Expose()
  @ApiPropertyOptional({
    type: Number,
    nullable: true,
    description: 'Sale price if on discount',
  })
  salePrice: number | null;

  @Expose()
  @ApiProperty({ type: String, description: 'Currency code (ISO 4217)' })
  currency: string;

  @Expose()
  @ApiProperty({
    enum: HealthServiceStatus,
    enumName: 'HealthServiceStatus',
    description: 'Status',
  })
  status: HealthServiceStatus;

  @Expose()
  @ApiProperty({ type: Boolean, description: 'Whether visible online' })
  isVisibleOnline: boolean;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Vendor name',
  })
  vendorName: string | null;

  @Expose()
  @ApiProperty({ type: Date, description: 'Creation timestamp' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ type: Date, description: 'Last update timestamp' })
  updatedAt: Date;

  @Expose()
  @Type(() => PartnerCategorySummaryDto)
  @ApiPropertyOptional({
    type: PartnerCategorySummaryDto,
    description: 'Category',
  })
  category: PartnerCategorySummaryDto | null;

  @Expose()
  @Type(() => PartnerHealthServiceMediaDto)
  @ApiPropertyOptional({
    type: [PartnerHealthServiceMediaDto],
    description: 'Media assets',
  })
  media: PartnerHealthServiceMediaDto[];

  @Expose()
  @Type(() => PartnerHealthServiceDefinitionDto)
  @ApiPropertyOptional({
    type: PartnerHealthServiceDefinitionDto,
    description: 'Definition for service type',
  })
  productDefinition: PartnerHealthServiceDefinitionDto | null;

  @Expose()
  @Type(() => PartnerHealthServiceEmployeeEligibilityDto)
  @ApiPropertyOptional({
    type: [PartnerHealthServiceEmployeeEligibilityDto],
    description: 'Eligible employees for service',
  })
  productEmployeeEligibilities: PartnerHealthServiceEmployeeEligibilityDto[];

  @Expose()
  @Type(() => PartnerServiceManualDto)
  @ApiPropertyOptional({
    type: PartnerServiceManualDto,
    description: 'Service manual (guidelines, rules, procedure steps)',
  })
  serviceManual: PartnerServiceManualDto | null;

  @Expose()
  @Type(() => PartnerProductTagDto)
  @ApiPropertyOptional({
    type: [PartnerProductTagDto],
    description: 'Feature tags associated with this service',
  })
  productTags: PartnerProductTagDto[];

  @Expose()
  @ApiPropertyOptional({
    type: [String],
    description: 'Tag IDs associated with this service',
  })
  tagIds: string[];
}
