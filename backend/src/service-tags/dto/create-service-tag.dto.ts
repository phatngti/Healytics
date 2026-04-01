import {
  IsString,
  IsOptional,
  IsBoolean,
  IsNotEmpty,
  IsInt,
  MaxLength,
  Min,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

/**
 * DTO for creating a new service tag.
 */
export class CreateServiceTagDto {
  @ApiProperty({ example: 'Premium Service', description: 'Tag name' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  name: string;

  @ApiPropertyOptional({ example: 'Tags for premium tier services' })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiPropertyOptional({
    example: '#FF6366F1',
    description: 'Color value as hex string',
  })
  @IsString()
  @IsOptional()
  colorValue?: string;

  @ApiPropertyOptional({
    example: true,
    description: 'Whether the tag is active',
  })
  @IsBoolean()
  @IsOptional()
  isActive?: boolean;

  @ApiPropertyOptional({ example: 0, description: 'Sort order for display' })
  @IsInt()
  @IsOptional()
  @Min(0)
  sortOrder?: number;
}
