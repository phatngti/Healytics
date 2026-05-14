import { Expose } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';

/**
 * Partner-facing service assignment summary for an employee details page.
 */
export class EmployeeAssignedServiceDto {
  @Expose()
  @ApiProperty({ type: String, description: 'Assigned service/product ID' })
  id: string;

  @Expose()
  @ApiProperty({ type: String, description: 'Service name' })
  name: string;

  @Expose()
  @ApiProperty({
    type: String,
    enum: HealthServiceStatus,
    enumName: 'HealthServiceStatus',
    description: 'Service lifecycle status',
  })
  status: HealthServiceStatus;

  @Expose()
  @ApiProperty({ type: Number, description: 'Base price in service currency' })
  basePrice: number;

  @Expose()
  @ApiPropertyOptional({
    type: Number,
    nullable: true,
    description: 'Sale price in service currency, when configured',
  })
  salePrice: number | null;

  @Expose()
  @ApiProperty({ type: String, description: 'Currency code' })
  currency: string;

  @Expose()
  @ApiPropertyOptional({
    type: Number,
    nullable: true,
    description: 'Service duration in minutes',
  })
  durationMinutes: number | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Service category name',
  })
  categoryName: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Preferred service image URL',
  })
  imageUrl: string | null;

  @Expose()
  @ApiProperty({
    type: Boolean,
    description: 'Whether this employee is primary for this service',
  })
  isPrimary: boolean;

  static fromEligibility(
    eligibility: ProductEmployeeEligibility,
  ): EmployeeAssignedServiceDto {
    const product = eligibility.product;
    const media = product.media ?? [];
    const thumbnail = media.find((item) => item.isThumbnail);
    const fallback = media
      .slice()
      .sort((left, right) => left.sortOrder - right.sortOrder)[0];

    const dto = new EmployeeAssignedServiceDto();
    dto.id = product.id;
    dto.name = product.name;
    dto.status = product.status;
    dto.basePrice = Number(product.basePrice);
    dto.salePrice =
      product.salePrice === null || product.salePrice === undefined
        ? null
        : Number(product.salePrice);
    dto.currency = product.currency;
    dto.durationMinutes = product.productDefinition?.durationMinutes ?? null;
    dto.categoryName = product.category?.name ?? null;
    dto.imageUrl = thumbnail?.url ?? fallback?.url ?? null;
    dto.isPrimary = eligibility.isPrimary;
    return dto;
  }
}
