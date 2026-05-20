import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { HealthServiceType } from '../../enums/health-service-type.enum';
import { HealthServiceStatus } from '../../enums/health-service-status.enum';

/**
 * Response DTO for category data within health service.
 */
class PublicCategorySummaryDto {
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
class PublicHealthServiceMediaDto {
  @Expose()
  @ApiProperty({ type: String, description: 'Unique media identifier' })
  id: string;

  @Expose()
  @ApiProperty({ type: String, description: 'Media URL' })
  url: string;

  @Expose()
  @ApiPropertyOptional({ type: String, description: 'Media type (image, video, etc.)' })
  mediaType?: string;

  @Expose()
  @ApiPropertyOptional({ type: Boolean, description: 'Whether this is the thumbnail' })
  isThumbnail?: boolean;

  @Expose()
  @ApiProperty({ type: Number, description: 'Sort order for display' })
  sortOrder: number;
}

/**
 * Response DTO for health service definition.
 * Matches ProductDefinition entity structure.
 */
class PublicHealthServiceDefinitionDto {
  @Expose()
  @ApiProperty({ type: String, description: 'Product ID (primary key)' })
  productId: string;

  @Expose()
  @ApiProperty({ type: Number, description: 'Service duration in minutes' })
  durationMinutes: number;

  @Expose()
  @ApiPropertyOptional({ type: Number, description: 'Buffer time between appointments' })
  bufferMinutes?: number;

  @Expose()
  @ApiPropertyOptional({ type: Number, description: 'Maximum capacity per slot' })
  maxCapacity?: number;

  @Expose()
  @ApiPropertyOptional({ type: Number, description: 'Minimum lead time for booking (hours)' })
  minLeadTimeHours?: number;

  @Expose()
  @ApiPropertyOptional({ type: String, description: 'Staff assignment type' })
  staffAssignmentType?: string;
}

/**
 * Response DTO for employee eligibility within health service.
 * Matches ProductEmployeeEligibility entity structure.
 */
class PublicHealthServiceEmployeeEligibilityDto {
  @Expose()
  @ApiProperty({ type: String, description: 'Product ID' })
  productId: string;

  @Expose()
  @ApiProperty({ type: String, description: 'Employee ID' })
  employeeId: string;

  @Expose()
  @ApiProperty({ type: Boolean, description: 'Whether this is the primary employee' })
  isPrimary: boolean;
}

/**
 * Health service response DTO for API responses.
 * Never expose raw entity data directly.
 */
export class PublicHealthServiceResponseDto {
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
  @ApiPropertyOptional({ type: String, nullable: true, description: 'Description' })
  description: string | null;

  @Expose()
  @ApiProperty({ enum: HealthServiceType, enumName: 'HealthServiceType', description: 'Type' })
  type: HealthServiceType;

  @Expose()
  @ApiProperty({ type: Number, description: 'Base price in specified currency' })
  basePrice: number;

  @Expose()
  @ApiPropertyOptional({ type: Number, nullable: true, description: 'Sale price if on discount' })
  salePrice: number | null;

  @Expose()
  @ApiProperty({ type: String, description: 'Currency code (ISO 4217)' })
  currency: string;

  @Expose()
  @ApiProperty({ enum: HealthServiceStatus, enumName: 'HealthServiceStatus', description: 'Status' })
  status: HealthServiceStatus;

  @Expose()
  @ApiProperty({ type: Boolean, description: 'Whether visible online' })
  isVisibleOnline: boolean;

  @Expose()
  @ApiPropertyOptional({ type: String, nullable: true, description: 'Vendor name' })
  vendorName: string | null;

  @Expose()
  @ApiProperty({ type: Date, description: 'Creation timestamp' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ type: Date, description: 'Last update timestamp' })
  updatedAt: Date;

  @Expose()
  @Type(() => PublicCategorySummaryDto)
  @ApiPropertyOptional({
    type: PublicCategorySummaryDto,
    description: 'Category',
  })
  category: PublicCategorySummaryDto | null;

  @Expose()
  @Type(() => PublicHealthServiceMediaDto)
  @ApiPropertyOptional({
    type: [PublicHealthServiceMediaDto],
    description: 'Media assets',
  })
  media: PublicHealthServiceMediaDto[];

  @Expose()
  @Type(() => PublicHealthServiceDefinitionDto)
  @ApiPropertyOptional({
    type: PublicHealthServiceDefinitionDto,
    description: 'Definition for service type',
  })
  productDefinition: PublicHealthServiceDefinitionDto | null;

  @Expose()
  @Type(() => PublicHealthServiceEmployeeEligibilityDto)
  @ApiPropertyOptional({
    type: [PublicHealthServiceEmployeeEligibilityDto],
    description: 'Eligible employees for service',
  })
  productEmployeeEligibilities: PublicHealthServiceEmployeeEligibilityDto[];
}
