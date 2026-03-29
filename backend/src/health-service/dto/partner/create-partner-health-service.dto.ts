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
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { HealthServiceType } from '@/health-service/enums/health-service-type.enum';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { MediaType } from '@/health-service/enums/media-type.enum';
import { StaffAssignmentType } from '@/health-service/enums/staff-assignment-type.enum';

// Nested DTOs
export class CreatePartnerHealthServiceMediaDto {
  @ApiProperty({ example: 'https://example.com/product.jpg' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(500)
  url: string;

  @ApiPropertyOptional({ enum: MediaType, example: MediaType.IMAGE })
  @IsEnum(MediaType)
  @IsOptional()
  mediaType?: MediaType;

  @ApiPropertyOptional({ example: true })
  @IsBoolean()
  @IsOptional()
  isThumbnail?: boolean;

  @ApiPropertyOptional({ example: 0 })
  @IsNumber()
  @IsOptional()
  sortOrder?: number;
}


export class CreatePartnerHealthServiceDefinitionDto {
  @ApiProperty({ example: 60, description: 'Duration in minutes' })
  @IsNumber()
  @IsNotEmpty()
  @Min(1)
  durationMinutes: number;

  @ApiPropertyOptional({ example: 15 })
  @IsNumber()
  @IsOptional()
  @Min(0)
  bufferMinutes?: number;

  @ApiPropertyOptional({ example: 1 })
  @IsNumber()
  @IsOptional()
  @Min(1)
  maxCapacity?: number;

  @ApiPropertyOptional({ example: 2 })
  @IsNumber()
  @IsOptional()
  @Min(0)
  minLeadTimeHours?: number;

  @ApiPropertyOptional({ enum: StaffAssignmentType, example: StaffAssignmentType.ANY })
  @IsEnum(StaffAssignmentType)
  @IsOptional()
  staffAssignmentType?: StaffAssignmentType;
}

export class CreatePartnerHealthServiceFacilityImageDto {
  @ApiProperty({ example: 'https://example.com/facility.jpg' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(500)
  imageUrl: string;

  @ApiProperty({ example: 'Treatment Room A' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  label: string;

  @ApiPropertyOptional({ example: 0 })
  @IsNumber()
  @IsOptional()
  sortOrder?: number;
}

export class ServiceRuleInputDto {
  @ApiProperty({ example: 'no-eating' })
  @IsString()
  @IsNotEmpty()
  iconSlug: string;

  @ApiProperty({ example: 'No Eating Before' })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty({ example: 'Avoid eating 2 hours before the service' })
  @IsString()
  @IsNotEmpty()
  description: string;
}

export class ProcedureStepInputDto {
  @ApiProperty({ example: 1 })
  @IsNumber()
  stepNumber: number;

  @ApiProperty({ example: 'Check-in & Registration' })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty({ example: 'Arrive at the reception and complete registration' })
  @IsString()
  @IsNotEmpty()
  description: string;
}

export class ServiceManualInputDto {
  @ApiPropertyOptional({ type: [String], example: ['Avoid heavy meals', 'Wear comfortable clothing'] })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  preServiceGuidelines?: string[];

  @ApiPropertyOptional({ type: [ServiceRuleInputDto] })
  @IsArray()
  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => ServiceRuleInputDto)
  serviceRules?: ServiceRuleInputDto[];

  @ApiPropertyOptional({ type: [ProcedureStepInputDto] })
  @IsArray()
  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => ProcedureStepInputDto)
  procedureSteps?: ProcedureStepInputDto[];
}

// Main DTO
export class CreatePartnerHealthServiceDto {


  @ApiPropertyOptional({ example: 'uuid-category-id' })
  @IsUUID()
  @IsOptional()
  categoryId?: string;

  @ApiProperty({ example: 'Thai Massage' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  name: string;

  @ApiProperty({ example: 'thai-massage' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  slug: string;

  @ApiPropertyOptional({ example: 'A relaxing Thai massage service' })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({ enum: HealthServiceType, example: HealthServiceType.SERVICE })
  @IsEnum(HealthServiceType)
  @IsNotEmpty()
  type: HealthServiceType;

  @ApiPropertyOptional({ example: 500000 })
  @IsNumber()
  @IsOptional()
  @Min(0)
  basePrice?: number;

  @ApiPropertyOptional({ example: 450000 })
  @IsNumber()
  @IsOptional()
  @Min(0)
  salePrice?: number;

  @ApiPropertyOptional({ example: 'VND' })
  @IsString()
  @IsOptional()
  @MaxLength(3)
  currency?: string;

  @ApiPropertyOptional({ enum: HealthServiceStatus, example: HealthServiceStatus.DRAFT })
  @IsEnum(HealthServiceStatus)
  @IsOptional()
  status?: HealthServiceStatus;

  @ApiPropertyOptional({ example: false })
  @IsBoolean()
  @IsOptional()
  isVisibleOnline?: boolean;

  @ApiPropertyOptional({ example: ['uuid-1', 'uuid-2'] })
  @IsArray()
  @IsUUID(undefined, { each: true })
  @IsOptional()
  employeeIds?: string[];

  // Nested objects
  @ApiPropertyOptional({ type: [CreatePartnerHealthServiceMediaDto], description: 'Product media (images/videos)' })
  @IsArray()
  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => CreatePartnerHealthServiceMediaDto)
  media?: CreatePartnerHealthServiceMediaDto[];

  @ApiPropertyOptional({ type: CreatePartnerHealthServiceDefinitionDto, description: 'Product definition (required if type is service)' })
  @IsOptional()
  @ValidateNested()
  @Type(() => CreatePartnerHealthServiceDefinitionDto)
  productDefinition?: CreatePartnerHealthServiceDefinitionDto;

  @ApiPropertyOptional({ type: [CreatePartnerHealthServiceFacilityImageDto], description: 'Facility/clinic images' })
  @IsArray()
  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => CreatePartnerHealthServiceFacilityImageDto)
  facilityImages?: CreatePartnerHealthServiceFacilityImageDto[];

  @ApiPropertyOptional({ type: ServiceManualInputDto, description: 'Service manual (guidelines, rules, procedure steps)' })
  @IsOptional()
  @ValidateNested()
  @Type(() => ServiceManualInputDto)
  serviceManual?: ServiceManualInputDto;
}
