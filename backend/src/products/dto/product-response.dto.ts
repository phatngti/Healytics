import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ProductType } from '../enums/product-type.enum';
import { ProductStatus } from '../enums/product-status.enum';

/**
 * Response DTO for category data within product.
 */
class CategorySummaryDto {
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
 * Response DTO for product media.
 * Matches ProductMedia entity structure.
 */
class ProductMediaDto {
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
 * Response DTO for service definition within product.
 * Matches ServiceDefinition entity structure.
 */
class ServiceDefinitionDto {
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
 * Response DTO for employee eligibility within product.
 * Matches ServiceEmployeeEligibility entity structure.
 */
class ServiceEmployeeEligibilityDto {
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
 * Product response DTO for API responses.
 * Never expose raw entity data directly.
 */
export class ProductResponseDto {
  @Expose()
  @ApiProperty({ description: 'Unique product identifier' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'Product name' })
  name: string;

  @Expose()
  @ApiProperty({ description: 'URL-friendly slug' })
  slug: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Product description' })
  description: string | null;

  @Expose()
  @ApiProperty({ enum: ProductType, description: 'Product type' })
  type: ProductType;

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
  @ApiProperty({ enum: ProductStatus, description: 'Product status' })
  status: ProductStatus;

  @Expose()
  @ApiProperty({ description: 'Whether product is visible online' })
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
  @Type(() => CategorySummaryDto)
  @ApiPropertyOptional({ type: CategorySummaryDto, description: 'Product category' })
  category: CategorySummaryDto | null;

  @Expose()
  @Type(() => ProductMediaDto)
  @ApiPropertyOptional({ type: [ProductMediaDto], description: 'Product media assets' })
  media: ProductMediaDto[];

  @Expose()
  @Type(() => ServiceDefinitionDto)
  @ApiPropertyOptional({ type: ServiceDefinitionDto, description: 'Service definition for service products' })
  serviceDefinition: ServiceDefinitionDto | null;

  @Expose()
  @Type(() => ServiceEmployeeEligibilityDto)
  @ApiPropertyOptional({ type: [ServiceEmployeeEligibilityDto], description: 'Eligible employees for service' })
  serviceEmployeeEligibilities: ServiceEmployeeEligibilityDto[];
}
