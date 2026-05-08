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
  ValidateIf,
  MaxLength,
  Min,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { HealthServiceType } from '@/health-service/enums/health-service-type.enum';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import {
  CreatePartnerHealthServiceMediaDto,
  CreatePartnerHealthServiceDefinitionDto,
  CreatePartnerHealthServiceFacilityImageDto,
  ServiceManualInputDto,
} from './create-partner-health-service.dto';

/**
 * Update DTO for health services.
 *
 * All properties are optional. For DB-nullable fields (categoryId, description,
 * salePrice, serviceManual, productDefinition, etc.) the client may send `null`
 * to explicitly clear the value. For non-nullable DB columns (name, slug, type,
 * basePrice, currency, status, isVisibleOnline) the client may omit the field
 * or send a valid value, but `null` will be stripped by the handler.
 */
export class UpdatePartnerHealthServiceDto {
  // ── Nullable DB columns — accept null to clear ──────────────────────

  @ApiPropertyOptional({ type: String, format: 'uuid', nullable: true })
  @ValidateIf((o) => o.categoryId !== null)
  @IsUUID()
  categoryId?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.description !== null)
  @IsString()
  description?: string | null;

  @ApiPropertyOptional({ type: Number, nullable: true })
  @ValidateIf((o) => o.salePrice !== null)
  @IsNumber()
  @Min(0)
  salePrice?: number | null;

  // ── Non-nullable DB columns — optional but never null ───────────────

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

  @ApiPropertyOptional({ enum: HealthServiceType, enumName: 'HealthServiceType' })
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

  // ── Relation arrays — accept null or [] to clear ────────────────────

  @ApiPropertyOptional({ type: [String], nullable: true })
  @ValidateIf((o) => o.employeeIds !== null)
  @IsArray()
  @IsUUID(undefined, { each: true })
  employeeIds?: string[] | null;

  @ApiPropertyOptional({
    type: [CreatePartnerHealthServiceMediaDto],
    nullable: true,
  })
  @ValidateIf((o) => o.media !== null)
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreatePartnerHealthServiceMediaDto)
  media?: CreatePartnerHealthServiceMediaDto[] | null;

  @ApiPropertyOptional({
    type: CreatePartnerHealthServiceDefinitionDto,
    nullable: true,
  })
  @ValidateIf((o) => o.productDefinition !== null)
  @ValidateNested()
  @Type(() => CreatePartnerHealthServiceDefinitionDto)
  productDefinition?: CreatePartnerHealthServiceDefinitionDto | null;

  @ApiPropertyOptional({
    type: [CreatePartnerHealthServiceFacilityImageDto],
    nullable: true,
  })
  @ValidateIf((o) => o.facilityImages !== null)
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreatePartnerHealthServiceFacilityImageDto)
  facilityImages?: CreatePartnerHealthServiceFacilityImageDto[] | null;

  @ApiPropertyOptional({ type: ServiceManualInputDto, nullable: true })
  @ValidateIf((o) => o.serviceManual !== null)
  @ValidateNested()
  @Type(() => ServiceManualInputDto)
  serviceManual?: ServiceManualInputDto | null;
}
