import {
  IsString,
  IsOptional,
  IsBoolean,
  IsNotEmpty,
  IsUUID,
  IsEnum,
  IsNumber,
  IsArray,
  ValidateNested,
  MaxLength,
  Min,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional, PartialType } from '@nestjs/swagger';
import { HealthServiceType } from '@/health-service/enums/health-service-type.enum';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import {
  CreatePartnerHealthServiceMediaDto,
  CreatePartnerHealthServiceDefinitionDto,
  CreatePartnerHealthServiceFacilityImageDto,
  ServiceManualInputDto,
} from './create-partner-health-service.dto';

export class UpdatePartnerHealthServiceDefinitionDto extends PartialType(
  CreatePartnerHealthServiceDefinitionDto,
) {}

/**
 * Update DTO for health services.
 *
 * All properties are optional. The controller applies `StripNullPropertiesPipe`
 * to remove any field whose value is `null` before validation runs, so only
 * fields with real values are validated and passed to the handler.
 *
 * To clear a nullable DB column, the frontend should simply omit the field
 * (or send `null`, which the pipe strips).
 */
export class UpdatePartnerHealthServiceDto {
  // ── DB columns ──────────────────────────────────────────────────────

  @ApiPropertyOptional({ type: String, format: 'uuid', nullable: true })
  @IsOptional()
  @IsUUID()
  categoryId?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ type: Number, nullable: true })
  @IsOptional()
  @IsNumber()
  @Min(0)
  salePrice?: number;

  @ApiPropertyOptional({ type: String })
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  name?: string;

  @ApiPropertyOptional({ type: String })
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  slug?: string;

  @ApiPropertyOptional({
    enum: HealthServiceType,
    enumName: 'HealthServiceType',
  })
  @IsOptional()
  @IsEnum(HealthServiceType)
  type?: HealthServiceType;

  @ApiPropertyOptional({ type: Number })
  @IsOptional()
  @IsNumber()
  @Min(0)
  basePrice?: number;

  @ApiPropertyOptional({ type: String })
  @IsOptional()
  @IsString()
  @MaxLength(3)
  currency?: string;

  @ApiPropertyOptional({ enum: HealthServiceStatus })
  @IsOptional()
  @IsEnum(HealthServiceStatus)
  status?: HealthServiceStatus;

  @ApiPropertyOptional({ type: Boolean })
  @IsOptional()
  @IsBoolean()
  isVisibleOnline?: boolean;

  // ── Relations ───────────────────────────────────────────────────────

  @ApiPropertyOptional({ type: [String], nullable: true })
  @IsOptional()
  @IsArray()
  @IsUUID(undefined, { each: true })
  employeeIds?: string[];

  @ApiPropertyOptional({
    type: [String],
    nullable: true,
    description:
      'Feature tag IDs to associate with this service (full replacement)',
  })
  @IsOptional()
  @IsArray()
  @IsUUID(undefined, { each: true })
  tagIds?: string[];

  @ApiPropertyOptional({
    type: [CreatePartnerHealthServiceMediaDto],
    nullable: true,
  })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreatePartnerHealthServiceMediaDto)
  media?: CreatePartnerHealthServiceMediaDto[];

  @ApiPropertyOptional({
    type: UpdatePartnerHealthServiceDefinitionDto,
    nullable: true,
  })
  @IsOptional()
  @ValidateNested()
  @Type(() => UpdatePartnerHealthServiceDefinitionDto)
  productDefinition?: UpdatePartnerHealthServiceDefinitionDto;

  @ApiPropertyOptional({
    type: [CreatePartnerHealthServiceFacilityImageDto],
    nullable: true,
  })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreatePartnerHealthServiceFacilityImageDto)
  facilityImages?: CreatePartnerHealthServiceFacilityImageDto[];

  @ApiPropertyOptional({ type: ServiceManualInputDto, nullable: true })
  @IsOptional()
  @ValidateNested()
  @Type(() => ServiceManualInputDto)
  serviceManual?: ServiceManualInputDto;
}
