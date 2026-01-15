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
 */
class ProductMediaDto {
  @Expose()
  @ApiProperty()
  id: string;

  @Expose()
  @ApiProperty()
  url: string;

  @Expose()
  @ApiPropertyOptional()
  altText?: string;

  @Expose()
  @ApiProperty()
  displayOrder: number;
}

/**
 * Response DTO for service definition within product.
 */
class ServiceDefinitionDto {
  @Expose()
  @ApiProperty()
  id: string;

  @Expose()
  @ApiProperty()
  durationMinutes: number;

  @Expose()
  @ApiPropertyOptional()
  maxCapacity?: number;

  @Expose()
  @ApiPropertyOptional()
  preparationMinutes?: number;
}

/**
 * Response DTO for employee eligibility within product.
 */
class ServiceEmployeeEligibilityDto {
  @Expose()
  @ApiProperty()
  employeeId: string;

  @Expose()
  @ApiPropertyOptional()
  isPrimary?: boolean;
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
