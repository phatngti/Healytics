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
import { ProductType } from '@/products/enums/product-type.enum';
import { ProductStatus } from '@/products/enums/product-status.enum';
import { MediaType } from '@/products/enums/media-type.enum';
import { StaffAssignmentType } from '@/products/enums/staff-assignment-type.enum';

// Nested DTOs
export class CreateProductMediaDto {
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


export class CreateServiceDefinitionDto {
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

// Main Product DTO
export class CreateProductDto {


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

  @ApiProperty({ enum: ProductType, example: ProductType.SERVICE })
  @IsEnum(ProductType)
  @IsNotEmpty()
  type: ProductType;

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

  @ApiPropertyOptional({ enum: ProductStatus, example: ProductStatus.DRAFT })
  @IsEnum(ProductStatus)
  @IsOptional()
  status?: ProductStatus;

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
  @ApiPropertyOptional({ type: [CreateProductMediaDto], description: 'Product media (images/videos)' })
  @IsArray()
  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => CreateProductMediaDto)
  media?: CreateProductMediaDto[];

  @ApiPropertyOptional({ type: CreateServiceDefinitionDto, description: 'Service definition (required if type is service)' })
  @IsOptional()
  @ValidateNested()
  @Type(() => CreateServiceDefinitionDto)
  serviceDefinition?: CreateServiceDefinitionDto;
}
